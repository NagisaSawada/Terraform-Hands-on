# ベーシックなAWS環境をTerraformで構築する
## 事前準備
 - EC2のキーペアを作成
 - tfstateファイルを保存するS3バケットを作成（バージョニング・暗号化・ブロックパブリックアクセスを設定）
## 作業環境
 - Cloud9（※今回はTerraformでIAM権限の作成をしたい為インスタンスプロファイルを”AdministratorAccess”ロールに変更する）  
 （※[参考記事](https://go-journey.club/archives/17029)）
## 今回構築する環境
 - 構成図  
 ![tf-configuration-diagram](/images/other/tf-configuration-diagram.png)
 - ディレクトリ構成
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
## 実行手順
   [1. asdfでTerraformをインストール](#1-asdfでterraformをインストール)  
   [2. プロバイダーの設定](#2-プロバイダーの設定)  
   [3. バックエンドにS3を設定](#3-バックエンドにs3を設定)  
   [4. Terraformの初期化](#4-terraformの初期化)  
   [5. 各moduleを作成](#5-各moduleを作成)  
   [6. Terraformの実行](#6-terraformの実行)  
   [7. 構築・接続の確認](#7-構築接続の確認)  
   [8. 環境の削除](#8-環境の削除)  

---

### **1. asdfでTerraformをインストール**
 - 公式ダウンロード
 ```
 $ git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
 ```
 - asdfをシェルで使えるように設定
  ```
  $ vi ~/.bashrc
  ```  
  ファイル内に下記を追記
 ```
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash" 
 ```  
 asdfのインストール確認
 ```
$ asdf version
 ```
  - 新規ディレクトリでTerraformをインストール
```
$ mkdir terraform-practice
$ cd terraform-practice/
$ touch .tool-versions
$ vi .tool-versions
```  
管理ファイルに下記バージョンを記載
```
terraform 〈指定するバージョン〉
```  
インストールコマンドの実行
```
$ asdf install
```
  
---

### **2. プロバイダーの設定**
 - `terraform-practice/environments/dev`配下に[provider.tf](/terraform-practive/environments/dev/provider.tf)を作成し、AWS東京リージョンのプロバイダーを設定

---

### **3. バックエンドにS3を設定**
 - tfstateの管理に、事前に作成していたS3バケットを使用する
 - `terraform-practice/environments/dev`配下に[backend.tf](/terraform-practive/environments/dev/backend.tf)を作成

---

### **4. Terraformの初期化**
 - `provider.tf`が格納されたディレクトリで初期化を実行
 - moduleを追加した際にも初期化を行う
 ```
 $ terraform init
 ```

---

### **5. 各moduleを作成**
 - 環境ごとに設定を分けやすい構成・moduleの再利用が可能な構成を意識しコードを作成  
 （各コードは下記ファイル名をクリックして閲覧可能）  
 （環境を複数作成する場合はenvironments配下に新たにディレクトリを切りdevとは違う変数を指定する）  
 terraform-practice\  
├── environments\  
│   └── dev\  
│       &emsp;├── [backend.tf](/terraform-practive/environments/dev/backend.tf)\  
│       &emsp;├── [main.tf](/terraform-practive/environments/dev/main.tf)\  
│       &emsp;├── [outputs.tf](/terraform-practive/environments/dev/outputs.tf)\  
│       &emsp;├── [provider.tf](/terraform-practive/environments/dev/provider.tf)\  
│       &emsp;└── [variables.tf](/terraform-practive/environments/dev/variables.tf)\
└── modules\  
&emsp; ├── alb\  
&emsp; │   ├── [main.tf](/terraform-practive/modules/alb/main.tf)\  
&emsp; │   ├── [outputs.tf](/terraform-practive/modules/alb/outputs.tf)\  
&emsp; │   └── [variables.tf](/terraform-practive/modules/alb/variables.tf)\  
&emsp; ├── ec2\
&emsp; │   ├── [main.tf](/terraform-practive/modules/ec2/main.tf)\  
&emsp; │   ├── [outputs.tf](/terraform-practive/modules/ec2/outputs.tf)\  
&emsp; │   └── [variables.tf](/terraform-practive/modules/ec2/variables.tf)\  
&emsp; ├── rds\  
&emsp; │   ├── [main.tf](/terraform-practive/modules/rds/main.tf)\  
&emsp; │   ├── [outputs.tf](/terraform-practive/modules/rds/outputs.tf)\  
&emsp; │   └── [variables.tf](/terraform-practive/modules/rds/variables.tf)\  
&emsp; ├── s3\  
&emsp; │   ├── [main.tf](/terraform-practive/modules/s3/main.tf)\  
&emsp; │   ├── [outputs.tf](/terraform-practive/modules/s3/outputs.tf)\  
&emsp; │   └── [variables.tf](/terraform-practive/modules/s3/variables.tf)\  
&emsp; └── vpc\  
&emsp; &emsp; ├── [main.tf](/terraform-practive/modules/vpc/main.tf)\  
&emsp; &emsp; ├── [outputs.tf](/terraform-practive/modules/vpc/outputs.tf)\  
&emsp; &emsp; └── [variables.tf](/terraform-practive/modules/vpc/variables.tf)\  
 - コードのフォーマットを整えるコマンドを実行
```
$ terraform fmt
```
 - ファイルの記述が正常であることを確認
```
$ terraform validate
```

---

### **6. Terraformの実行**
 - ドライランでリソースの追加・更新・削除の実行計画を確認
```
$ terraform plan
```
 - 実際にデプロイする
```
$ terraform apply
```  
  実行結果  
  ![apply](/images/other/apply.png)
 - バックエンドに設定したS3バケットに`tfstate`が作成されていることを確認  
![backend-s3-dev](/images/other/backend-s3-dev.png)  
![backend-s3-tfstate](/images/other/backend-s3-tfstate.png)

---

### **7. 構築・接続の確認**
#### 構築確認
 - VPC  
 VPCの設定  
 ![create-vpc](/images/vpc/create-vpc-dev.png)  
 ネットワークへの接続  
 ![route-table](/images/vpc/route-table-dev.png)
 - EC2  
EC2の設定  
![create-ec2](/images/ec2/create-ec2-dev.png)  
![create-ec2-2](/images/ec2/create-ec2-dev-2.png)  
EC2のセキュリティグループ  
![ec2-sg-in](/images/ec2/ec2-sg-in-dev.png)  
![ec2-sg-out](/images/ec2/ec2-sg-out-dev.png)  
S3へのアクセスロール  
![ec2-iam-role](/images/ec2/ec2-iam-role-dev.png)  
![s3-acces-role](/images/ec2/s3-acces-role-dev.png)
 - ALB  
 ALBの設定  
 ![create-alb](/images/alb/create-alb-dev.png)  
 ALBのリスナー  
 ![alb-listener](/images/alb/alb-listener-dev.png)  
 ALBのターゲット  
 ![alb-target](/images/alb/alb-target-dev.png)  
 ALBのセキュリティグループ  
 ![alb-sg-in](/images/alb/alb-sg-in-dev.png)  
 ![alb-sg-out](/images/alb/alb-sg-out-dev.png)
 - RDS  
 RDSの設定  
 ![create-rds](/images/rds/create-rds-dev.png)  
 RDSのセキュリティグループ  
 ![rds-sg-in](/images/rds/rds-sg-in-dev.png)  
 ![rds-sg-out](/images/rds/rds-sg-out-dev.png)
 - S3  
 バケットの確認  
![s3-configuration](/images/s3/s3-configuration-dev.png)    

 #### 接続確認
 - EC2へSSH接続確認  
   ![ec2-ssh-connection](/images/ec2/ec2-ssh-connection-dev.png)
 - EC2からRDSへ接続確認  
   <details><summary>接続確認までの手順</summary>  

   MySQLのインストールから接続まで  
   ```
   $ sudo yum update  
   $ sudo yum install mysql  
   $ mysql -u 〈マスターユーザー名〉 -p -h 〈RDSのエンドポイント〉  
   # Secrets Managerのシークレットからパスワードを入力
   ```

   </details>  
  ![ec2-to-rds](/images/rds/ec2-to-rds-dev.png)
 - EC2で起動させているNginxのwelcomeページをALBのDNSをブラウザで叩いて表示させる  
   <details><summary>接続までの手順</summary>  

   Nginxのインストールから接続まで
   ```
   $ sudo amazon-linux-extras install nginx1  
   $ nginx -v  
   nginx version: nginx/1.22.1  
   $sudo systemctl start nginx.service  
   $sudo systemctl status nginx.service
   ```  

   </details>  
  ![start-nginx](/images/other/start-nginx-dev.png)  
  ![alb-to-nginx](/images/other/alb-to-nginx-dev.png)

---

### **8. 環境の削除**
 今回作成したリソースを削除コマンドを実行して削除する  
 ```
 $ terraform destroy
 ```
 ![destroy](/images/other/destroy.png)

---

