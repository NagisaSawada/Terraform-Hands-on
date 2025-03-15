# ベーシックなAWS環境をTerraformで構築する
## 今回の目的
 - 初めてTerraformで環境構築するにあたりその概要を理解する
## 工夫した点
 - module機能の導入により構成ファイルの組織化・再利用性アップを図る
 - 作成するリソース名に一貫性を持たせるよう、接尾辞をvariablesで指定する
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
## 学んだこと
 - ドライランで構成の変更を確認出来る点が非常に便利だということ。
 - module機能を使用し複数環境を簡単に構築するには、variablesで環境変数やリソース名を設定すると良いということ。  
   試しにenvironments配下にprod環境を作成してみたら初めは環境が衝突してリソースが作成できなかったが、変数定義や代入・受け取りの場所（親モジュール・子モジュール）を改めたら修正に持って行くことが出来た。
 - CloudFormationはAWSに特化し、シンプルなリソース管理が行える。  
   Terraformはマルチクラウド環境を一元管理し、柔軟なインフラ運用が行える。  
   これらを踏まえ、今後携わるプロジェクトがどのようにIaCを使い分けているのか、その目的を考えていこうと思った。
 - 今回は簡易的な構成だったが、workspaceを使った複数環境の構築にも挑戦してみたい。 
### 詳細
 - 今回の実行手順を[tf-practice.md](/tf-practice.md)にまとめた  
 - 作成したコードはterraform-practice配下に格納  

