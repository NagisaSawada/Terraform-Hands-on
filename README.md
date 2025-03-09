# ベーシックなAWS環境をTerraformで構築する
## 今回の目的
 - 初めてTerraformで環境構築するにあたりその概要を理解する
 - module機能の導入により構成ファイルの組織化・再利用性アップを図る
## 構成図
![tf-configuration-diagram](/images/other/tf-configuration-diagram.png)
## ディレクトリ構成
```
  terraform-practice
    ├── environments
    │   └── dev
    │       ├── backend.tf
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── provider.tf
    │       └── variables.tf
    └── modules
        ├── alb
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── ec2
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── rds
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── s3
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        └── vpc
            ├── main.tf
            ├── outputs.tf
            └── variables.tf  
```
### 詳細
 - 今回行ったことを[tf-practice.md](/tf-practice.md)にまとめた  
 - 作成したコードはterraform-practice配下に格納  

