Persiapan
- Copy and paste folder ProjectTemplate ke folder Project mu
- Rename folder ProjectTemplate yang dicopy menjadi nama project baru

Pastikan
- Di build settings, ubah lokasi bridging header menjadi:
    $(EXECUTABLE_NAME)/Supporting Files/Project-Bridging-Header.h
- Di build settings, ubah lokasi info.plist file menjadi:
    $(EXECUTABLE_NAME)/Supporting Files/Info.plist
*Sebaiknya di ProjectTemplate yg original juga diubah, agar ketika mengcopy lagi sudah sesuai
*Tujuan perubahan path ini agar lokasi file dinamis sesuai nama project

Step 1 - Rename project
- Buka project baru
- Klik project di "Project Navigation" (sisi kiri view, icon berwarna biru)
- Kemudian di sisi kiri di "File Inspector" ganti nama di "Identity and Type" menjadi nama project baru
- Klik "Rename" di pop up yg muncul

Step 2 - Rename Scheme
- Di bar atas (disamping "Stop" tombol build), disana ada nama project lama, klik kemudian pilih "Manage Schemes"
- Klik nama scheme lama, kemudian edit nama menjadi nama project baru

Step 3 - Rename xcworkspace
- Quit XCode.
- Di master folder, ubah ProjectTemplate.xcworkspace menjadi NEW.xcworkspace

Step 4 - Rename the folder with your assets
- Di "Project navigator" sisi kiri, klik master folder asset yg punya nama ProjectTemplate
- Di sisi kanan "Identity and type" ubah nama folder menjadi nama project baru

Step 5 - Reinstall pod:
- Quit xcode
- Di Podfile file, rename target ProjectTemplate menjadi nama project
- Run pod install.
- Buka XCode.
- Klik nama project di "Project Navigation"
- Buka menu "Build Phases" tab.
- DI Link Binary With Libraries, hapus lib yg menandakan ProjectTemplate

Step 6 - Refreshing Storyboard & SwiftGen
- Buka setiap storyboard yg ada kemudian reinstall salah satu custom class viewcontroller dengan cara  hapus dulu custom class -> Enter, kemudian masukkan ulang custom class -> Enter
- Buka file swiftgen.yml , rename ProjectTemplate menjadi nama project baru/ sesuai nama master folder
- Build 2x
- Bila ada error di build ke 2 cek ulang source code storyboard, pastikan tidak ada customModule bernama ProjectTemplate, bila ada rename dengan nama project baru
