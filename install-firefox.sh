#!/bin/bash

is_user_root() {
    ! (( ${EUID:-0} || $(id -u) ))
}

if is_user_root; then

    TEMP_PATH=$(mktemp -d)
    FIREFOX_DOWNLOAD_PATH="$TEMP_PATH/firefox.tar.bz2"
    /usr/sbin/groupadd firefox
    rm -rf /opt/firefox

    wget 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US' -O "$FIREFOX_DOWNLOAD_PATH"
    tar -xvjf "$FIREFOX_DOWNLOAD_PATH" -C /opt

    chown -R nobody:firefox /opt/firefox
    chmod -R u=g /opt/firefox/

    update-alternatives --install /usr/bin/firefox firefox /opt/firefox/firefox 1000
    update-alternatives --install /usr/bin/x-www-browser x-www-browser /opt/firefox/firefox 1000
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /opt/firefox/firefox 1000
    update-alternatives --set firefox /opt/firefox/firefox
    update-alternatives --set x-www-browser /opt/firefox/firefox
    update-alternatives --set gnome-www-browser /opt/firefox/firefox

    rm -rf $TEMP_PATH

    echo "[Desktop Entry]
Name=Firefox
Name[bg]=Firefox
Name[ca]=Firefox
Name[cs]=Firefox
Name[el]=Firefox
Name[es]=Firefox
Name[fa]=Firefox
Name[fi]=Firefox
Name[fr]=Firefox
Name[hu]=Firefox
Name[it]=Firefox
Name[ja]=Firefox
Name[ko]=Firefox
Name[nb]=Firefox
Name[nl]=Firefox
Name[nn]=Firefox
Name[no]=Firefox
Name[pl]=Firefox
Name[pt]=Firefox
Name[pt_BR]=Firefox
Name[ru]=Firefox
Name[sk]=Firefox
Name[sv]=Firefox
Comment=Browse the World Wide Web
Comment[bg]=Сърфиране в Мрежата
Comment[ca]=Navegueu per el web
Comment[cs]=Prohlížení stránek World Wide Webu
Comment[de]=Im Internet surfen
Comment[el]=Περιηγηθείτε στον παγκόσμιο ιστό
Comment[es]=Navegue por la web
Comment[fa]=صفحات شبکه جهانی اینترنت را مرور نمایید
Comment[fi]=Selaa Internetin WWW-sivuja
Comment[fr]=Navigue sur Internet
Comment[hu]=A világháló böngészése
Comment[it]=Esplora il web
Comment[ja]=ウェブを閲覧します
Comment[ko]=웹을 돌아 다닙니다
Comment[nb]=Surf på nettet
Comment[nl]=Verken het internet
Comment[nn]=Surf på nettet
Comment[no]=Surf på nettet
Comment[pl]=Przeglądanie stron WWW 
Comment[pt]=Navegue na Internet
Comment[pt_BR]=Navegue na Internet
Comment[ru]=Обозреватель Всемирной Паутины
Comment[sk]=Prehliadanie internetu
Comment[sv]=Surfa på webben
X-GNOME-FullName=Firefox Web Browser
X-GNOME-FullName[bg]=Интернет браузър (Firefox)
X-GNOME-FullName[ca]=Navegador web Firefox
X-GNOME-FullName[cs]=Firefox Webový prohlížeč
X-GNOME-FullName[el]=Περιηγήτης Ιστού Firefox
X-GNOME-FullName[es]=Navegador web Firefox
X-GNOME-FullName[fa]=مرورگر اینترنتی Firefox
X-GNOME-FullName[fi]=Firefox-selain
X-GNOME-FullName[fr]=Navigateur Web Firefox
X-GNOME-FullName[hu]=Firefox webböngésző
X-GNOME-FullName[it]=Firefox Browser Web
X-GNOME-FullName[ja]=Firefox ウェブ・ブラウザ
X-GNOME-FullName[ko]=Firefox 웹 브라우저
X-GNOME-FullName[nb]=Firefox Nettleser
X-GNOME-FullName[nl]=Firefox webbrowser
X-GNOME-FullName[nn]=Firefox Nettlesar
X-GNOME-FullName[no]=Firefox Nettleser
X-GNOME-FullName[pl]=Przeglądarka WWW Firefox
X-GNOME-FullName[pt]=Firefox Navegador Web
X-GNOME-FullName[pt_BR]=Navegador Web Firefox
X-GNOME-FullName[ru]=Интернет-браузер Firefox
X-GNOME-FullName[sk]=Internetový prehliadač Firefox
X-GNOME-FullName[sv]=Webbläsaren Firefox
Exec=/usr/bin/firefox 
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Firefox
StartupNotify=true" > /usr/share/applications/firefox.desktop

else
    echo 'Please run as superuser'
fi