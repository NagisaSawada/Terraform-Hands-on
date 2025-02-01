# CloudFormationで構築した環境をTerraformで構築する
## 今回の目的
 - 初めてTerraformで環境構築するにあたりその概要を理解する 
 - module機能の導入により構成ファイルの組織化・再利用性アップを図る
## 事前準備
 - EC2のキーペアを作成
 - tfstateファイルを保存するS3バケットを作成（バージョニング・暗号化・ブロックパブリックアクセスを設定）
## 作業環境
 - Cloud9（※今回はTerraformでIAM権限の作成をしたい為インスタンスプロファイルを”AdministratorAccess”ロールに変更する）  
 （※[参考記事](https://go-journey.club/archives/17029)）
## 今回構築する環境
 - 構成図  
 ![tf-configration-diagram](/images/other/tf-configration-diagram.png)
 - ディレクトリ構成
   ```
    terraform-practice
    ├── environments
    │   └── dev
    │       ├── backend.tf
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── provider.tf
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
 - `terraform-practice/environments/dev`配下に[provider.tf](/tf-practice-sub/environments-dev/provider.tf)を作成し、AWS東京リージョンのプロバイダーを設定

---

### **3. バックエンドにS3を設定**
 - tfstateの管理に、事前に作成していたS3バケットを使用する
 - `terraform-practice/environments/dev`配下に[backend.tf](/tf-practice-sub/environments-dev/backend.tf)を作成

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
 terraform-practice\  
├── environments\  
│   └── dev\  
│        &emsp;├── [backend.tf](/tf-practice-sub/environments-dev/backend.tf)\  
│        &emsp;├── [main.tf](/tf-practice-sub/environments-dev/main.tf)\  
│        &emsp;├── [outputs.tf](/tf-practice-sub/environments-dev/outputs.tf)\  
│        &emsp;└── [provider.tf](/tf-practice-sub/environments-dev/provider.tf)\  
└── modules\  
&emsp; ├── alb\  
&emsp; │   ├── [main.tf](/tf-practice-sub/modules/alb/main.tf)\  
&emsp; │   ├── [outputs.tf](/tf-practice-sub/modules/alb/outputs.tf)\  
&emsp; │   └── [variables.tf](/tf-practice-sub/modules/alb/variables.tf)\  
&emsp; ├── ec2\
&emsp; │   ├── [main.tf](/tf-practice-sub/modules/ec2/main.tf)\  
&emsp; │   ├── [outputs.tf](/tf-practice-sub/modules/ec2/outputs.tf)\  
&emsp; │   └── [variables.tf](/tf-practice-sub/modules/ec2/variables.tf)\  
&emsp; ├── rds\  
&emsp; │   ├── [main.tf](/tf-practice-sub/modules/rds/main.tf)\  
&emsp; │   ├── [outputs.tf](/tf-practice-sub/modules/rds/outputs.tf)\  
&emsp; │   └── [variables.tf](/tf-practice-sub/modules/rds/variables.tf)\  
&emsp; ├── s3\  
&emsp; │   ├── [main.tf](/tf-practice-sub/modules/s3/main.tf)\  
&emsp; │   ├── [outputs.tf](/tf-practice-sub/modules/s3/outputs.tf)\  
&emsp; │   └── [variables.tf](/tf-practice-sub/modules/s3/variables.tf)\  
&emsp; └── vpc\  
&emsp; &emsp; ├── [main.tf](/tf-practice-sub/modules/vpc/main.tf)\  
&emsp; &emsp; ├── [outputs.tf](/tf-practice-sub/modules/vpc/outputs.tf)\  
&emsp; &emsp; └── variables.tf\  # 今回は空ファイル
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
 ![create-vpc](/images/vpc/create-vpc.png)  
 ネットワークへの接続  
 ![route-table](/images/vpc/route-table.png)
 - EC2  
EC2の設定  
![create-ec2](/images/ec2/create-ec2.png)  
![create-ec2-2](/images/ec2/create-ec2-2.png)  
EC2のセキュリティグループ  
![ec2-sg-in](/images/ec2/ec2-sg-in.png)  
![ec2-sg-out](/images/ec2/ec2-sg-out.png)  
S3へのアクセスロール  
![ec2-iam-role](/images/ec2/ec2-iam-role.png)  
![s3-acces-role](/images/ec2/s3-acces-role.png)
 - ALB  
 ALBの設定  
 ![create-alb](/images/alb/create-alb.png)  
 ALBのリスナー  
 ![alb-listener](/images/alb/alb-listener.png)  
 ALBのターゲット  
 ![alb-target](/images/alb/alb-target.png)  
 ALBのセキュリティグループ  
 ![alb-sg-in](/images/alb/alb-sg-in.png)  
 ![alb-sg-out](/images/alb/alb-sg-out.png)
 - RDS  
 RDSの設定  
 ![create-rds](/images/rds/create-rds.png)  
 RDSのセキュリティグループ  
 ![rds-sg-in](/images/rds/rds-sg-in.png)  
 ![rds-sg-out](/images/rds/rds-sg-out.png)
 - S3  
 バケットの確認  
![s3-configuration](/images/s3/s3-configuration.png)    

 #### 接続確認
 - EC2へSSH接続確認  
   ![ec2-ssh-connection](/images/ec2/ec2-ssh-connection.png)
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
  ![ec2-to-rds](/images/rds/ec2-to-rds.png)
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
  ![start-nginx](/images/other/start-nginx.png)  
  ![alb-to-nginx](/images/other/alb-to-nginx.png)

---

### **8. 環境の削除**
 今回作成したリソースを削除コマンドを実行して削除する  
 ```
 $ terraform destroy
 ```
 ![destroy](/images/other/destroy.png)

---

## 感想
 - CloudFormationはAWS専用ツールだったが、Terraformはマルチクラウド対応な為、今後業務に就いた際使うことが出てくるかもしれない。その練習が出来て良かった。
 - ドライランで構成の変更を確認出来る点が非常に便利だった。
 - CloudFormationはAWSに特化し、シンプルなリソース管理が行える。  
 Terraformはマルチクラウド環境を一元管理し、柔軟なインフラ運用が行える。  
 これらを踏まえ、今後携わるプロジェクトがどのようにIaCを使い分けているのか、その目的を考えていこうと思った。
 - 今回は簡易的な構成だったが、workspaceを使った複数環境の構築にも挑戦してみたい。

