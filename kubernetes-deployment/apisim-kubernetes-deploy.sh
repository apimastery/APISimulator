#!/bin/sh
#-------------------------------------------------------------------------------
# Script to deploy API Simulator pods on a Kubernetes or OpenShift cluster
# along with the configuration for an API Simulation.
#
# Kubernetes requirements:
# * The version of Kubernetes must support projected volumes - 1.6.0+
# * In the Deployment yaml, use Kubernetes API versions as follows:
#   apps/v1               version 1.9.0+
#   apps/v1beta2          version 1.8.0
#   apps/v1beta1          version 1.7.0
#   extensions/v1beta1    version 1.6.0 and before
#
# The approach is as follows:
# - Auto-discover all (configuration) files in the API Simulation's directory
#   and sub-directories.
# - Create one configMap per file (e.g. simlet.yaml, external body content
#   files) while taking care of using valid configMap names, keys, and values.
# - Generate yaml deployment configuration that mounts a volume with the
#   configuration files from the configMap-s as 'projected' sources.
#
# This works with binary body content stored in external file when using
# Kubernetes v1.10+ apiserver and kubelet.
#
# Creating a single configMap with all API Simulation configuration files
# doesn't work because the configMap can become too big and cause deployment
# error like this one (in Kubernetes v1.10):
# "...ERROR: The ConfigMap "<name>" is invalid: []: Too long: must have at
# most 1048576 characters"
#-------------------------------------------------------------------------------
#set -x

# Fail on a single failed command
set -e


abend() {
  echo $1
  echo ""
  exit $2
}


info() {
  echo ""
  echo ">> $1"
}


toAbsDirPath() {
  # Execute it in another shell to avoid actually changing the current directory
  (
    cd "$1"
    local l_fqdn="${PWD}"
    local l_file=${PWD##*/}
    echo "$l_fqdn"/"$l_file"
  )
}


# This implementarion doesn't handle properly "." or ".." for argument but works for files
toAbsFilePath() {
  # Execute it in another shell to avoid actually changing the current directory
  (
    cd $(dirname "$1")
    local l_fqdn="$PWD"
    local l_file=$(basename "$1")
    echo "$l_fqdn"/"$l_file"
  )
}


is_valid_dns_subdomain() {
  echo "$1" | grep -E "^[a-z0-9]([a-z0-9\-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9\-]*[a-z0-9])?)*$" > /dev/null && return 0
  return 1
}


printUsageAndExit() {
  echo ""
  echo "Usage:"
  echo "$0 $ARG_SIM_DIR=<simulation-directory> [$ARG_VARS_FILE=<file-spec>] [$ARG_DRY_RUN] [$ARG_HELP]"
  echo "where:"
  echo "  $ARG_SIM_DIR    Required absolute or relative path to the directory with the API Simulation configuration. The directory name has to be a valid DNS subdomain name and will be used as name for the simulation and the Kubernetes deployment."
  echo "  $ARG_VARS_FILE  Optional argument for a file with configuration variables for Kubernetes deployment."
  echo "  $ARG_DRY_RUN    When present, this optional argument will cause no actual deployment to take place but commands and configuration will be printed out."
  echo "  $ARG_HELP       Prints this message and exists."
  echo ""
}


ARG_HELP="--help"
ARG_SIM_DIR="--sim-dir"
ARG_VARS_FILE="--vars-file"
ARG_DRY_RUN="--dry-run"

v_sim_dir=""
v_vars_file=""
v_dry_run="no"

while [ "$1" != "" ]; do
  v_arg_name=`echo $1 | awk -F= '{print $1}'`
  v_arg_value=`echo $1 | sed 's/^[^=]*=//g'`
  case $v_arg_name in
    -h | $ARG_HELP)
      printUsageAndExit
      exit
      ;;
    $ARG_SIM_DIR)
      v_sim_dir="$v_arg_value"
      ;;
    $ARG_VARS_FILE)
      v_vars_file="$v_arg_value"
      ;;
    $ARG_DRY_RUN)
      v_dry_run=yes
      ;;
    *)
      echo "ERROR: unknown argument \"$v_arg_name\""
      printUsageAndExit
      exit 1
      ;;
  esac
  shift
done


test -z "$v_sim_dir" && abend "ERROR: API Simulation directory \"$ARG_SIM_DIR\" argument not provided" 100
if [ ! -d "$v_sim_dir" ]
then
  abend "ERROR: API Simulation directory \"$v_sim_dir\" doesn't exist" 101
fi
# Extract the absolute API Simulation directory path and just the directory name as API Simulation name
v_sim_fqdn=$(toAbsDirPath "$v_sim_dir")
v_sim_dir=$(dirname "$v_sim_fqdn")
v_sim_name=$(basename "$v_sim_fqdn")


# Assure the API Simulation name is a valid DNS subdomain name
v_sim_name=$(echo "$v_sim_name" | tr A-Z a-z)
if ! is_valid_dns_subdomain "$v_sim_name"; then
  abend "ERROR: API Simulation name is not a valid DNS subdomain name=$v_sim_name" 103
fi

if [ -f "$v_vars_file" ]
then
  info "Sourcing '$v_vars_file' as file with API Simulation configuration variables for Kubernetes deployment..."
  . "$v_vars_file"
elif [ ! -z "$v_vars_file" ]; then
  abend "ERROR: File \"$v_vars_file\" doesn't exist" 102
else
  info "File with API Simulation configuration variables for Kubernetes deployment not specified - using defaults!"
fi
v_vars_fqfn=$(toAbsFilePath "$v_vars_file")


CLI=${CLI:-"kubectl"}

APISIM_NAMESPACE=${APISIM_NAMESPACE:-"apisimulator"}
APISIM_IMAGE=${APISIM_IMAGE:-"apimastery/apisimulator:1.0.0"}
APISIM_DEPLOYMENT_API_VERSION=${APISIM_DEPLOYMENT_API_VERSION:-"apps/v1"}
APISIM_REPLICAS=${APISIM_REPLICAS:-1}
APISIM_IMAGE_PULL_POLICY=${APISIM_IMAGE_PULL_POLICY:-"IfNotPresent"}
APISIM_POD_RESTART_POLICY=${APISIM_POD_RESTART_POLICY:-"Always"}
APISIM_POD_TERMINATION_GRACE_SECS=${APISIM_POD_TERMINATION_GRACE_SECS:-5}

APISIM_CPU_REQUEST=${APISIM_CPU_REQUEST:-"100m"}
APISIM_CPU_LIMIT=${APISIM_CPU_LIMIT-"500m"}
APISIM_MEMORY_REQUEST=${APISIM_MEMORY_REQUEST:-"320Mi"}
APISIM_MEMORY_LIMIT=${APISIM_MEMORY_LIMIT:-"512Mi"}

APISIM_SERVICE_CLUSTER_IP=${APISIM_SERVICE_CLUSTER_IP:-""}
APISIM_SERVICE_TYPE=${APISIM_SERVICE_TYPE:-"NodePort"}
APISIM_SERVICE_NODE_PORT=${APISIM_SERVICE_NODE_PORT:-""}

APISIMULATOR_JAVA=${APISIMULATOR_JAVA:-""}
APISIMULATOR_HEAP_SIZE=${APISIMULATOR_HEAP_SIZE:-"-Xms256m -Xmx256m"}
APISIMULATOR_OPTS=${APISIMULATOR_OPTS:-""}


# The first command is to delete all configMap-s for the simulation
v_cmdCreateConfigMaps="$CLI -n ${APISIM_NAMESPACE} delete configmap -l app=$v_sim_name"

# Initialize few variables that will be used later on
v_deploymentConfigMaps=""

# Auto-discover all files in the API Simulation configuration directory
for v_file in $(find "$v_sim_dir" -type f -exec ls -1p {} \; 2> /dev/null); do
  v_fqfn=$v_file

  # Skip the vars file
  test "$v_fqfn" = "$v_vars_fqfn" && continue

  v_sim_config_file=$(echo "$v_file" | sed -e "s|$v_sim_dir/||1;")

  # A configMap name has to be valid DNS subdomain name:
  # - it cannot contain "/", "..", "_"
  # - these are only valid in certain position: "-"
  # - all letters have to be small case
  v_configMap_name="$v_sim_name.$v_sim_config_file"
  v_configMap_name=$(echo "$v_configMap_name" | tr "/" ".")
  v_configMap_name=$(echo "$v_configMap_name" | sed -e "s|\.\.||g;")
  v_configMap_name=$(echo "$v_configMap_name" | sed -e "s|_||g;")
  v_configMap_name=$(echo "$v_configMap_name" | tr A-Z a-z)

  if ! is_valid_dns_subdomain "$v_configMap_name"; then
    abend "ERROR: Not a valid DNS subdomain name=$v_configMap_name" 101
  fi

  # The same key name in all configMap-s
  v_configMap_key="file"

  # Command to create configMap with data from a file
  v_cmdCreateConfigMap="$CLI -n ${APISIM_NAMESPACE} create configmap $v_configMap_name --from-file=$v_configMap_key=$v_fqfn"

  # Label the configMap so it can be selectivly deleted by the label
  v_cmdCreateConfigMap=$v_cmdCreateConfigMap";$CLI -n ${APISIM_NAMESPACE} label configmap $v_configMap_name app=$v_sim_name"

  # Accumulate all commands to create configMap-s
  v_cmdCreateConfigMaps="$v_cmdCreateConfigMaps;$v_cmdCreateConfigMap"

  # Keep the indentation spaces!!!
  v_deploymentConfigMap="
          - configMap:
              name: $v_configMap_name
              items:
              - key: $v_configMap_key
                path: $v_sim_name/$v_sim_config_file"

  # Accumulate all configMap-s that will be mounted
  v_deploymentConfigMaps="$v_deploymentConfigMaps$v_deploymentConfigMap"
done


# Set some configuration variables based on the processing so far
APISIM_APP_NAME="$v_sim_name"
APISIM_DEPLOYMENT_NAME="$v_sim_name"
APISIM_SERVICE_NAME="${APISIM_APP_NAME}-svc"
APISIM_CONFIGMAP_SOURCES="$v_deploymentConfigMaps"
API_SIMULATION_NAME="$v_sim_name"


info "Deleting the old configMap-s for the simulation (if any) and creating new ones..."
# Split the commands using ';' as the delimiter
IFS=$';'
v_commands_list=$v_cmdCreateConfigMaps
for v_command in ${v_commands_list}; do
  # Execute the command to create the configMap-s
  if [ "$v_dry_run" = "yes" ]; then
    echo "$v_command"
  else
    echo $v_command | sh
  fi
done
unset IFS


v_deployment_yaml=$(cat << EOF
apiVersion: ${APISIM_DEPLOYMENT_API_VERSION}
kind: Deployment
metadata:
  namespace: "${APISIM_NAMESPACE}"
  name: "${APISIM_DEPLOYMENT_NAME}"
  labels:
    app: "${APISIM_APP_NAME}"
spec:
  replicas: ${APISIM_REPLICAS}
  selector:
    matchLabels:
      app: "${APISIM_APP_NAME}"
  template:
    metadata:
      labels:
        app: "${APISIM_APP_NAME}"
      name: "${APISIM_DEPLOYMENT_NAME}"
    spec:
      volumes:
      - name: apisim
        projected:
          sources:
${APISIM_CONFIGMAP_SOURCES}
      containers:
        - name: apisimulator
          image: ${APISIM_IMAGE}
          volumeMounts:
          - name: apisim
            mountPath: "/apisim"
          env:
          - name: APISIMULATOR_JAVA
            value: "${APISIMULATOR_JAVA}"
          - name: APISIMULATOR_HEAP_SIZE
            value: "${APISIMULATOR_HEAP_SIZE}"
          - name: APISIMULATOR_OPTS
            value: "${APISIMULATOR_OPTS}"
          command: ["apisimulator"]
          args: [
            "start",
            "/apisim/${API_SIMULATION_NAME}"
          ]
          ports:
          - name: sim
            containerPort: 6090
            protocol: TCP
          - name: adm
            containerPort: 6190
            protocol: TCP
          resources:
            requests:
              cpu: ${APISIM_CPU_REQUEST}
              memory: ${APISIM_MEMORY_REQUEST}
            limits:
              cpu: ${APISIM_CPU_LIMIT}
              memory: ${APISIM_MEMORY_LIMIT}
          terminationMessagePath: /dev/termination-log
          imagePullPolicy: ${APISIM_IMAGE_PULL_POLICY}
      restartPolicy: ${APISIM_POD_RESTART_POLICY}
      terminationGracePeriodSeconds: ${APISIM_POD_TERMINATION_GRACE_SECS}
      dnsPolicy: ClusterFirst
      securityContext: {}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
EOF
)
info "Deleting the old deployment (if it exists), creating new one, and starting ${APISIM_REPLICAS} replicas..."
if [ "$v_dry_run" = "yes" ]; then
  # Change IFS to have whitespaces preserved by `echo`.
  IFS=$'\n' && echo "$v_deployment_yaml" && unset IFS
else
  # Delete deployment by label, if it exists. Deleting by name will cause an error when deployment is missing.
  $CLI -n ${APISIM_NAMESPACE} delete deployment -l app="$APISIM_APP_NAME"
  echo "$v_deployment_yaml" | $CLI -n ${APISIM_NAMESPACE} create -f -
fi


v_service_yaml=$(cat << EOF
apiVersion: v1
kind: Service
metadata:
  namespace: "${APISIM_NAMESPACE}"
  name: "${APISIM_SERVICE_NAME}"
  labels:
    app: "${APISIM_APP_NAME}"
    name: "${APISIM_SERVICE_NAME}"
spec:
  type: ${APISIM_SERVICE_TYPE}
  clusterIP: ${APISIM_SERVICE_CLUSTER_IP}
  ports:
  - port: 6090
    protocol: TCP
    targetPort: 6090
    $([ $(echo "$APISIM_SERVICE_TYPE" | tr A-Z a-z) = "nodeport" ] && echo "nodePort: $APISIM_SERVICE_NODE_PORT")
  selector:
    app: "${APISIM_APP_NAME}"
  sessionAffinity: None
EOF
)
info "Deleting the old service for the API Simulation (if it exists) and creating new one..."
if [ "$v_dry_run" = "yes" ]; then
  IFS=$'\n' && echo "$v_service_yaml" && unset IFS
else
  # Delete service by label, if it exists. Deleting by name will cause an error when service is missing.
  $CLI -n ${APISIM_NAMESPACE} delete svc  -l app="$APISIM_APP_NAME"
  echo "$v_service_yaml" | $CLI -n ${APISIM_NAMESPACE} create -f -
fi


info "DONE."
# @END
