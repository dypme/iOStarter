Cara merubah nama proyek secara full
1. Siapkan folder untuk melakukan perubahan pada proyek, pastikan di folder tsb tidak ada file apapun (Contoh folder: "NewProjectFolder")
2. Copy proyek (iOS_Starter) ke folder yg telah dibuat 
3. Buka terminal
4. Masuk ke folder yg telah dibuat\
cd /Path/NewProjectFolder
5. Install tool tambahan (bila sudah pernah, lewati)\
brew install rename ack
6. Masukkan code \
find . -name 'iOS_Starter*' -print0 | xargs -0 rename --subst-all 'iOS_Starter' 'NamaProjekBaru'\
Tidak masalah bila output ada error
7. Ulangi langkah nomor 6 hingga tidak ada output error
8. Cek ulang bahwa semua kata iOS_Starter sudah berubah semua (Hasil outpu akan kosong) dengan code \
find . -name 'iOS_Starter*'
9. Masukkan code\
ack --literal --files-with-matches 'iOS_Starter' --print0 | xargs -0 sed -i '' 's/iOS_Starter/NamaProjekBaru/g'
10. Cek lagi\
ack --literal 'iOS_Starter'
11. Install ulang pod\
pod install
12. Build proyek
13. Pindah/ Cut proyek baru ke folder yg sesuai/ biasa untuk menyimpan proyek
