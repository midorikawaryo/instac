# リファクタ: コントローラの認証共通化・重複削除・Favorites#destroy のバグ修正

## 概要
認証処理の共通化、各コントローラの重複コード削除、および `FavoritesController#destroy` の潜在バグ修正を行った。

## 変更内容

### 1. 認証の共通化（ApplicationController）
- **`require_login`** を追加し、未ログイン時は `new_session_path` へリダイレクトするように統一
- 全コントローラで `before_action :require_login` が効くようにし、各所にあった `login_user` を削除
- **SessionsController**: `skip_before_action :require_login, only: [:new, :create]` でログイン・新規作成は未ログインでアクセス可能に
- **UsersController**: `skip_before_action :require_login, only: [:new, :create]` で新規登録は未ログインでアクセス可能に

### 2. PicturesController
- `login_user` を削除し、ApplicationController の `require_login` に一本化
- `ensure_correct_user` 内で `@picture` を再取得していたのをやめ、`set_picture` で設定した `@picture` を利用するように変更
- `@current_user` を `current_user` に統一（SessionsHelper のメソッド利用）
- `before_action` の `only` の表記を統一（末尾カンマ・スペース）
- `picture_params` の permit のカンマ表記を統一

### 3. UsersController
- **`set_user`** を追加し、`show` / `edit` / `update` / `destroy` / `favorite_index` で `@user = User.find(params[:id])` の重複を削除
- `ensure_correct_user` で `@user` を再取得していたのをやめ、`set_user` 済みの `@user` と `current_user` の比較のみに変更
- `user_path` の引数漏れを修正（`redirect_to user_path` → `redirect_to user_path(@user)`）
- `destroy` は現状ルート未定義のため空のまま。TODO コメントを追加

### 4. FavoritesController#destroy（バグ修正）
- `find_by(id: params[:id])` が `nil` の場合に `.destroy` で NoMethodError になる可能性を解消
- `destroy` の**後**に `favorite.picture.user.name` を参照していたため、destroy 後に関連が消える可能性を考慮し、**destroy 前に** `owner_name` を変数に保持してから `destroy` するように変更
- お気に入りが見つからない場合は「お気に入りが見つかりません」でリダイレクトするようにした

### 5. その他
- 各コントローラの private メソッドのインデント・空行を整理
- 挙動は変えず、既存の「ログイン必須」「本人のみ編集可能」の仕様を維持

## テスト
- 既存のコントローラテスト・モデルテストが通ることを確認することを推奨
- 特に `SessionsController`（未ログインで new/create にアクセス可能）、`UsersController`（未ログインで new/create にアクセス可能）、`FavoritesController#destroy`（存在しない id でエラーにならないこと）の動作確認を推奨

## ブランチ
- `refactor/controllers-auth-and-dry` → `master` へのマージを想定
