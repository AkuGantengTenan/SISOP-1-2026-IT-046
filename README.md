# Sisop-1-2026

<details>
<summary>Soal 1</summary>

**Penjelasan** 

Pertama kita buat file KANJ.sh

```awk
BEGIN {
    FS = ","
    if (soal != "a" && soal != "b" && soal != "c" && soal != "d" && soal != "e") {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f file.sh data.csv a"
        exit
    }
}
```
Di bagian ini kita inisialisasi Blok BEGIN dijalankan satu kali di awal sebelum AWK membaca baris apapun dari file CSV. Pertama, FS = "," berfungsi untuk memberitahu AWK bahwa pemisah antar kolom adalah karakter koma. Tanpa baris ini, AWK akan menggunakan spasi sebagai pemisah default sehingga data CSV tidak akan terbaca dengan benar. Kemudian if bertugas memvalidasi nilai variabel soal yang dikirim lewat -v soal=a. Jika nilai soal bukan salah satu dari a, b, c, d, atau e, maka program akan mencetak pesan error.


```awk
NR > 1 {
    count_passenger++
    gerbong[$4] = 1
    total_age += $2
    if ($2 > max_age) {
        max_age = $2
        oldest  = $1
    }
    if ($3 == "Business") business_passenger++
}
```
Kondisi NR > 1 memastikan baris pertama yang merupakan header  dilewati dan pemrosesan baru dimulai dari baris ke-2. count_passenger++ menambah counter penumpang sebanyak 1 setiap kali ada baris baru. Kemudian gerbong[$4] = 1 menyimpan nama gerbong dari kolom ke-4 ke dalam sebuah array, maka gerbong yang sama tidak dihitung dua kali. Selanjutnya total_age += $2 menjumlahkan usia seluruh penumpang dari kolom ke-2 yang nantinya digunakan untuk menghitung rata-rata. if ($2 > max_age) membandingkan usia setiap penumpang dengan usia tertinggi yang sudah ditemukan sebelumnya, jika lebih besar maka nilai max_age dan oldest diperbarui dengan usia dan nama penumpang tersebut. Terakhir, if ($3 == "Business") mengecek kolom ke-3 yaitu kelas kursi, jika nilainya Business maka business_passenger ditambah 1.


```awk
END {
    if (soal == "a")
        print "Jumlah seluruh penumpang KANJ adalah " count_passenger " orang"
    else if (soal == "b") {
        for (g in gerbong) carriage++
        print "Jumlah gerbong penumpang KANJ adalah " carriage
    }
    else if (soal == "c")
        print oldest " adalah penumpang kereta tertua dengan usia " max_age " tahun"
    else if (soal == "d") {
        average_age = int(total_age / count_passenger + 0.5)
        print "Rata-rata usia penumpang adalah " average_age " tahun"
    }
    else if (soal == "e")
        print "Jumlah penumpang business class ada " business_passenger " orang"
}
```
Di bagian ini seluruh perhitungan dari kode bagian 1 & 2 akan ditampilkan dengan menggunakan metode percabangan if else untuk soal a sampai dengan soal e. 

**Output**

<img width="889" height="466" alt="Screenshot 2026-03-24 221001" src="https://github.com/user-attachments/assets/91615ad8-4f87-4595-b2ba-1784da8248ad" />

soal a akan mencetak total seluruh penumpang yang ada di dalam file CSV
soal b mencetak jumlah gerbong unik yang digunakan dalam perjalanan. 
soal c  mencetak nama dan usia penumpang tertua dari proses perbandingan usia setiap penumpang.
soal d mencetak rata-rata usia seluruh penumpang yang sudah dibulatkan. Nilai 38 didapat dari hasil pembagian total_age dengan count_passenger
soal e mencetak jumlah penumpang yang memilih kelas Business. 

**Kendala**  
Tidak ada kendala

</details>

<details>
<summary>Soal 2</summary>

**Penjelasan**  
Isi penjelasan Anda di sini.

**Output**  


**Kendala**  
Tidak ada kendala / [jelaskan kendala jika ada]

</details>

<details>
<summary>Soal 3</summary>

**Penjelasan**  
Isi penjelasan Anda di sini.

**Output**  



**Kendala**  
Tidak ada kendala / [jelaskan kendala jika ada]

</details>

