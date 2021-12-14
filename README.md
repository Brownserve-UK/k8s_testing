# k8s_testing
Playing with Kubernetes as part of the Linux Foundation course

To create a joining token
```sh
sudo kubeadm token create
openssl x509 -pubkey \
    -in /etc/kubernetes/pki/ca.crt | openssl rsa \
    -pubin -outform der 2>/dev/null | openssl dgst \
    -sha256 -hex | sed 's/ˆ.* //'
```

To join the worker
```sh
sudo kubeadm join \
    --token <token> \
    kube-primary:6443 \
    --discovery-token-ca-cert-hash \
    sha256:<openssl_sha>
```