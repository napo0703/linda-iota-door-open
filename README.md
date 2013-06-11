Iota-Door Linda Client
======================

- https://github.com/masuilab/iota-door-linda-client/issues
- やまだくんがドアを開けた
- ["door", "open"]を読んでドアを開ける
  - [linda-base](http://linda.masuilab.org/iota/door/open)から開けられる
- ["door", "open", "success"]を書き込む


## Demo

https://www.youtube.com/watch?v=8yryQBdIyvs


## 必要な物をインストール

    % gem install bundler
    % bundle install


サーボモータをArduinoの10番ピンに接続する


## 使用するArduinoを指定（必要あれば）

    % export ARDUINO=/dev/tty.usb-device-name


## 実行

    % export LINDA_BASE=http://linda.masuilab.org
    % export LINDA_SPACE=iota
    % bundle exec ruby main.rb


## ドア開け単体でテスト

    % bundle exec ruby lib/iota_door.rb


## サービスとしてインストール
-----------------------------

for launchd (Mac OSX)

    % sudo foreman export launchd /Library/LaunchDaemons/ --app linda-door-iota -u `whoami`
    % sudo launchctl load -w /Library/LaunchDaemons/linda-door-iota-open-1.plist

for upstart (Ubuntu)

    % sudo foreman export upstart /etc/init/ --app linda-door-iota -d `pwd` -u `whoami`
    % sudo service linda-door-iota start
