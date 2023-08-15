# ⚪︎AWS ALB Controller

・aws/に移動し、環境変数の適用(※内容をそれぞれに合わせて変更すること)

```
source tfvars.env
```

・vpc⇨rds⇨eks の順で、terraform apply

・~/.kube/config の更新（kubectl コマンドを作成した EKS で使用できるようにする）

```
aws eks update-kubeconfig --name <cluster_name>  --region ap-northeast-1
```

・alb を terraform apply

・AWS Load Balancer Controller のインストール

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=demo-cluster -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
```

※AWS Load Balancer Controller のアンインストール

```
helm uninstall aws-load-balancer-controller -n kube-system
```

・deply⇨service⇨ingress の順で apply

※外部通信がないときの通信確認方法（ポートフォワード）
　 ⇨ 　`website pod`への接続の場合

```
kubectl port-forward svc/website 8080:80
```

※注意事項

```
AWS Load Balancer Controllerを使用するときは、Serviceのタイプは、NodePortを指定する
```

# ⚪︎IRSA

・Pod に最小権限を与える

・irsa 配下を terraform apply し、IAM Role と service account を作成

・Pod に service account を関連づけ、deploy

```
kubectl apply -f s3_exec.yaml
```

・s3 を参照できているか確認(complete となっていれば成功)

```
kubectl get pod
```

# ⚪︎RBAC

・IAM ユーザーに cluster 内の運用・監視権限を与える

・rbac 配下 を terraform apply し、EKS assume role をアタッチした IAM ユーザーを作成

・新規ユーザーの認証情報を登録

```
aws configure --profile <new-user>

export AWS_PROFILE=<new-user>
aws sts get-caller-identity
```

・読み取り専用の cluserrolebinding を作成

```
kubectl apply -f clusterrolebinding

kubectl clusterrolebinding view-clusterrolebinding
```

・現在の aws-auth の確認

```
kubectl get cm aws-auth -n kube-system -o yaml
```

・aws_auth_update.yml を修正し、aws-auth を更新

```
kubectl apply -f aws_auth_update.yml
```

・新規ユーザーに切り替え

```
export AWS_PROFILE=<new-user>
aws sts get-caller-identity
```

・assume role にスイッチ（下記は、12 時間ロールが有効）

```
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/RbacDemoRole --role-session-name RbacDemoSession --duration-seconds 43200
```

・セッション情報を環境変数に設定

```
export AWS_ACCESS_KEY_ID=<AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<SecretAccessKey>
export AWS_SESSION_TOKEN=<SessionToken>
```

・get,delete ができるか確認(参照はできるが、削除はできない)

```
kubectl auth can-i get pods
yes

kubectl auth can-i delete pods
no
```

※assume role を終了させる(下記コマンド、もしくは Terminal を切り替える)

```
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```
