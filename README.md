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

**Output**  


**Kendala**  
Tidak ada kendala / [jelaskan kendala jika ada]

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

