# eks-demo

⚫️aws/に移動し、環境変数の適用

```
source tfvars.env
```

⚫️vpc⇨rds⇨eks⇨albの順で、terraform apply

⚫️`AWS Load Balancer Controller`のインストール

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=demo-cluster -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
```

※`AWS Load Balancer Controller`のアンインストール

```
helm uninstall aws-load-balancer-controller -n kube-system
```

⚫️deply⇨service⇨ingressの順でapply

※外部通信がないときの通信確認方法（ポートフォワード）
 　⇨ `website pod`への接続の場合
```
kubectl port-forward svc/website 8080:80
```

※注意事項

```
Serviceのタイプは、NodePortを指定する
```
