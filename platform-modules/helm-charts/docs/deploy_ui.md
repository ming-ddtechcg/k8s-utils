# deploy_ui
deploy_ui is the a text UI to help deploying/undeploying the Helm chart over the Kubernetst system.

The file is available under each chart's "utils" directory, except the charts are under the "packages" directory.

The menu is show below in general:

```console
<no chart is selected yet> deployment
======================================================================
namespace: 
chart name: 
values file: 

options
1.  namespace
2.  select values file
3.  edit values file
4.  generate template YAML
5.  debugging installation
6.  install
7.  uninstall
8.  package

18. shell environment
19. loop this menu for refreshing screen
20. exit
```

Few hightlight options in the UI, they are:

- option 1: namespace
  the namespace is for storing the chart as well as the resources to be deployed in.  However, the values.yaml file may define the resource namespace, and left the namespace is for storing the chart only.
- option 8: package
  this option is to package the chart into the tgz format and the values.yaml file with the templates directory will be used in the package rather than other values.yaml files outside the chart.

