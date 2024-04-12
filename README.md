## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add omicx-helm https://mpt-tiendc.github.io/omicx-helm

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
omicx-helm` to see the charts.

To install the omicx-helm chart:

    helm install omicx omicx-helm/omicx

To uninstall the chart:

    helm delete omicx

From Tiendc with love <3