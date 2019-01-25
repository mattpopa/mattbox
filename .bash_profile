#bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#standard-path
export PATH="/usr/local/opt/curl/bin:/usr/local/sbin:/usr/local/bin:$PATH"

# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

#mysql-client
export PATH="/usr/local/opt/mysql-client/bin:$PATH" 

#python3
#export PATH="/usr/local/opt/python/libexec/bin:$PATH"

#python2
export PATH=/usr/local/share/python:$PATH

#yq
export PATH=/Users/mpopa/Library/Python/2.7/bin:$PATH

export EDITOR="`which vim`"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

#export KOPS_STATE_STORE=ToBeConfigured

#tf debug
#export TF_LOG=DEBUG
#export TF_LOG_PATH="/tmp/tf_aloalo.log"
#export TF_VAR_dbs_pass="$(security find-generic-password -a dbs_pass -w)"

# Makes sense if you use K8
#export KUBECONFIG="/address/to/you/k8/file"

# Quick text file that comes in handy
alias daily="vim ~/Documents/dailystuff.txt"

# Other aliases
alias awslist="aws iam list-instance-profiles"
alias git_clean_local_branches="git branch | grep -v develop | xargs git branch -D"
alias git_where_is_this="git branch -r --contains "

# Terraform Aliases
# alias tf="terraform"
# alias tf_app="terraform apply -var 'keep_old=false' -var 'cutover=true'"
# alias tf_add="terraform apply -var 'keep_old=false' -var 'cutover=true'"
# alias tf_plan="terraform plan -var 'keep_old=false' -var 'cutover=true'"
# alias tf_dest="(echo true && sleep 7; echo false && sleep 5 && echo yes) | terraform destroy"
# alias tf_get="terraform get"
# alias tf_env="terraform workspace list"
# alias tf_sel="terraform workspace select"
# alias tf_ref="terraform refresh -var 'keep_old=false' -var 'cutover=true'"
# alias tf_init="terraform init"

# Quicky find out your public IP
alias ip="curl icanhazip.com"

alias ll="ls -latrh"
