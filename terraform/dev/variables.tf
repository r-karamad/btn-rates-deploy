variable namespace {
  type        = string
  description = "Namespace for deployment"
}

variable btn_release_name {
  type        = string
  description = "btn-rates helm release name"
}

variable btn_repository   {
  type        = string
  description = "btn helm repostiory"
}

variable btn_chart   {
  type        = string
  description = "btn helm chart name"
}

variable btn_chart_version {
  type        = string
  default     = ""
  description = "btn helm chart version"
}

variable btn_host {
  type        = string
  description = "btn host"
}