package main

import (
	"context"
	"flag"
	"fmt"
	"os"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"sigs.k8s.io/yaml"
)

const (
	namespace     = "kube-system"
	configMapName = "kubeadm-config"
)

type clusterConfiguration struct {
	Networking struct {
		DNSDomain     string `json:"dnsDomain"`
		PodSubnet     string `json:"podSubnet"`
		ServiceSubnet string `json:"serviceSubnet"`
	} `json:"networking"`
}

func buildConfig() (*rest.Config, error) {
	if kubeconfig := os.Getenv("KUBECONFIG"); kubeconfig != "" {
		return clientcmd.BuildConfigFromFlags("", kubeconfig)
	}
	return rest.InClusterConfig()
}

func main() {
	showDNSDomain := flag.Bool("dns-domain", false, "show the value of dnsDomain")
	showPodSubnet := flag.Bool("pod-subnet", false, "show the value of podSubnet")
	showServiceSubnet := flag.Bool("service-subnet", false, "show the value of serviceSubnet")
	flag.Parse()

	if !*showDNSDomain && !*showPodSubnet && !*showServiceSubnet {
		*showDNSDomain, *showPodSubnet, *showServiceSubnet = true, true, true
	}

	config, err := buildConfig()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error building kubernetes config: %v\n", err)
		os.Exit(1)
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error creating kubernetes client: %v\n", err)
		os.Exit(1)
	}

	cm, err := clientset.CoreV1().ConfigMaps(namespace).Get(context.Background(), configMapName, metav1.GetOptions{})
	if err != nil {
		fmt.Fprintf(os.Stderr, "error fetching configmap %s/%s: %v\n", namespace, configMapName, err)
		os.Exit(1)
	}

	raw, ok := cm.Data["ClusterConfiguration"]
	if !ok {
		fmt.Fprintf(os.Stderr, "configmap %s/%s has no ClusterConfiguration key\n", namespace, configMapName)
		os.Exit(1)
	}

	var clusterConfig clusterConfiguration
	if err := yaml.Unmarshal([]byte(raw), &clusterConfig); err != nil {
		fmt.Fprintf(os.Stderr, "error parsing ClusterConfiguration: %v\n", err)
		os.Exit(1)
	}

	if *showDNSDomain {
		fmt.Printf("dnsDomain=%s\n", clusterConfig.Networking.DNSDomain)
	}
	if *showPodSubnet {
		fmt.Printf("podSubnet=%s\n", clusterConfig.Networking.PodSubnet)
	}
	if *showServiceSubnet {
		fmt.Printf("serviceSubnet=%s\n", clusterConfig.Networking.ServiceSubnet)
	}
}
