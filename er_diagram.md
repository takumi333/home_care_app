### ER図

ER図:https://gyazo.com/43b2bb60315708770c7254533d65d044

### 各テーブルの説明

#### usersテーブル
FK:user_type_id(ユーザータイプID)
   name(ユーザー名)
   email(メールアドレス)
   password(パスワード)
   shared_number(共有者ID)
   is_demo_user(お試しユーザーか判定)

(役割)
全ユーザー情報を管理するためのテーブル。
(説明)
ユーザータイプ(患者・家族・医療従事者)は、整合性向上の観点から、外部キーとして格納。
shared_numberカラムを作成することで、ユーザーインターフェース上での、ユーザー識別番号を共有者IDとして作成可能に。
共有者IDの存在によって、インターフェース上で直接IDカラムを使用せず、自由にユーザー同士での共有追加が可能に。
is_demo_user(お試しユーザーか判定)で、お試しモードでのログインか判別。

####  user_typesテーブル
name(ユーザータイプ)

患者・家族・医療従事者という3種類のユーザータイプを管理。

#### health_recordsテーブル
FK1:input_user_id(入力者)
FK2:patient_user_id(患者名)
FK3:health_level_id(調子レベル)
    record_date(記録日)
    systolic_blood_pressure(収縮期血圧)
    diastolic_blood_pressure(拡張期血圧)
    is_bathing(入浴の有無)
    memo(メモ)

(役割)
どの入力者とどの患者の記録なのかを紐付ける・体調管理機能の項目を管理するためのテーブル。
(説明)
input_user_id(入力者)は、現在のログインユーザーが自動的に割り当てられるロジックを組むために、usersテーブルから取得。
patient_user_id(患者名)は、usersテーブルから患者名を。
さらに、適切な患者の選択肢を表示するため、usersテーブルと繋がっているshare_personsテーブルに格納されている入力者と共有関係にある患者名を取得する。
health_level_id(調子レベル)外部キーで、調子レベルの選択肢を取得。


#### health_levelsテーブル
condition(体調レベル度)

(役割)
体調レベルの項目を管理するためのテーブル。
(説明)
「大変良い」「良い」「普通」「あまり良くない」「良くない」という5種類の項目を管理

#### user_sharesテーブル
sharer_id(共有者)
shared_id(共有される者)

(役割)
誰が誰と共有関係なのかを管理するためのテーブル。
(説明)
共有者たちの詳細情報は、usersテーブルから取得。
ログインユーザーが、共有者追加ページにて、共有者IDを入力追加した際、ログインユーザーをsharer_idへ
追加されたユーザーをshared_idへ格納。

#### chat_recordsテーブル
Fk1:sender_id(送信者)
FK2:recipient_id(受信者)
content(内容)
send_time(送信日時)

(役割)
チャット相手の管理・チャット内容の管理をするためのテーブル。
(説明)
Fk1:sender_id(送信者)、FK2:recipient_id(受信者)で、チャット間のユーザー関連付け・履歴の取得を行う。
content(内容)にて、チャットの内容を保存。
send_timeにて、特定のチャットの送信日時を保存。

#### medicine_recordsテーブル
FK1:input_user_id(入力者)
FK2:patient_user_id(患者名)
FK3:take_medicines_id(服薬タイミングID)
confirmation(服薬チェック)
name(薬名)
dosage(投薬量)
start_date(開始日時)
end_date(終了日時)
memo(メモ)

(役割)
患者の服薬スケジュール管理・薬の登録情報(薬の登録者と患者の紐付け)の管理をするためのテーブル。
(説明)
input_user_id(入力者)は、現在のログインユーザーが自動的に割り当てられるロジックを組むために、usersテーブルから取得。
patient_user_id(患者名)は、usersテーブルから患者名を。
さらに、適切な患者の選択肢を表示するため、usersテーブルと繋がっているshare_personsテーブルに格納されている入力者と共有関係にある患者名を取得する。
take_medicines_id(服薬タイミングID)外部キーで、take_medicenesテーブルから、服薬タイミングの選択肢を取得。

#### take_medicenesテーブル
timing(服薬タイミング)

(役割)
服薬タイミングの項目を管理するためのテーブル。
(説明)
「朝食前」「朝食後」「昼食前」「昼食後」「夕食前」「夕食後」「就寝前」「頓服」の8種類の管理項目


その他説明

・患者一覧ページ(医療従事者のみ閲覧可能)
usersテーブルのデータから、ログインユーザーのユーザータイプが「医療従事者」であることを判別。
「医療従事者」の場合、さらにログインユーザーがsharer_id(共有者)の場合の、shared_id(共有される者)に関連付けされている患者のみを取得。


・体調リストの食事欄画像アップロード機能
active storageを採用するため、health_recordsテーブル内に、画像保存用カラムは入れない。
