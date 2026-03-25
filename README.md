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
Setelah kita install File peta-ekspedisi-amba.pdf via gdown kita lakukan langkah berikut

```
pdftotext -layout peta-ekspedisi-amba.pdf isi-peta.txt
cat isi-peta.txt
```
langkah tersebut bertujuan untuk membaca file peta-ekspedisi-amba.pdf agar dapat menemukan tautan yang tersembunyi. 

```
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git peta-gunung-kawi
```
Kita install semua isi repository dari GitHub ke folder lokal = peta-gunung-kawi. Di dalamnya ada file gsxtrack.json yang berisi data koordinat titik-titik ekspedisi paman Amba.

```awk
#!/bin/bash

INPUT="gsxtrack.json"
OUTPUT="titik-penting.txt"

> "$OUTPUT"

ids=$(grep -oP '"id":\s*"\K[^"]+' "$INPUT")
names=$(grep -oP '"site_name":\s*"\K[^"]+' "$INPUT")
lats=$(grep -oP '"latitude":\s*\K[-0-9.]+' "$INPUT")
lons=$(grep -oP '"longitude":\s*\K[-0-9.]+' "$INPUT")

IFS=$'\n' read -r -d '' -a arr_ids   <<< "$ids"
IFS=$'\n' read -r -d '' -a arr_names <<< "$names"
IFS=$'\n' read -r -d '' -a arr_lats  <<< "$lats"
IFS=$'\n' read -r -d '' -a arr_lons  <<< "$lons"

for i in "${!arr_ids[@]}"; do
    echo "${arr_ids[$i]},${arr_names[$i]},${arr_lats[$i]},${arr_lons[$i]}" >> "$OUTPUT"
done

echo "Parsing selesai. Hasil disimpan di $OUTPUT"
cat "$OUTPUT"
```
Script ini berfungsi untuk mengekstrak data koordinat dari file gsxtrack.json dan menyimpannya ke dalam file titik-penting.txt. Pertama, script mengosongkan file output dengan perintah > "$OUTPUT" untuk mencegah duplikasi data jika script dijalankan lebih dari satu kali. Selanjutnya, script menggunakan grep -oP dengan regex Perl untuk mengekstrak empat field secara terpisah yaitu id, site_name, latitude, dan longitude dari file JSON. Pola regex seperti '"id":\s*"\K[^"]+' bekerja dengan cara mengabaikan bagian "id": dan hanya mengambil nilainya saja, sedangkan untuk angka desimal seperti latitude dan longitude digunakan pola [-0-9.]+ agar bisa menangkap angka negatif dan titik desimal. Hasil dari setiap grep kemudian dikonversi menjadi array bash menggunakan IFS=$'\n' read -r -d '' -a agar tiap nilai bisa diakses berdasarkan index. Terakhir, script melakukan looping berdasarkan index array untuk menggabungkan keempat field dari node yang sama menjadi satu baris dengan format id,site_name,latitude,longitude dan menuliskannya ke file titik-penting.txt.

```awk
#!/bin/bash

INPUT="titik-penting.txt"
OUTPUT="posisipusaka.txt"

lat1=$(awk -F',' 'NR==1 {print $3}' "$INPUT")
lon1=$(awk -F',' 'NR==1 {print $4}' "$INPUT")

lat3=$(awk -F',' 'NR==3 {print $3}' "$INPUT")
lon3=$(awk -F',' 'NR==3 {print $4}' "$INPUT")

lat_pusat=$(echo "scale=10; ($lat1 + $lat3) / 2" | bc)
lon_pusat=$(echo "scale=10; ($lon1 + $lon3) / 2" | bc)

echo "Koordinat pusat: $lat_pusat,$lon_pusat"
echo "$lat_pusat,$lon_pusat" > "$OUTPUT"

echo "Hasil disimpan di $OUTPUT"
```
Script nemupusaka.sh berfungsi untuk menghitung koordinat titik tengah dari keempat node yang telah diekstrak sebelumnya, berdasarkan petunjuk sang Dukun bahwa lokasi pusaka berada tepat di tengah dari semua titik bekas ekspedisi paman. Pertama, script membaca file titik-penting.txt menggunakan awk dengan delimiter koma (-F',') untuk mengambil nilai latitude dan longitude dari node_001 (baris ke-1) dan node_003 (baris ke-3). Kedua node tersebut dipilih karena keempat titik membentuk sebuah persegi, sehingga node_001 dan node_003 merupakan titik yang saling berseberangan secara diagonal. Titik tengah kemudian dihitung menggunakan rumus titik tengah persegi yaitu (x1 + x2) / 2 untuk latitude dan (y1 + y2) / 2 untuk longitude, dengan bantuan perintah bc yang memungkinkan operasi aritmatika dengan presisi tinggi hingga 10 angka desimal (scale=10). Hasil koordinat pusat kemudian disimpan ke dalam file posisipusaka.txt dengan format latitude,longitude, dimana koordinat tersebut menunjukkan lokasi tepat dimana benda pusaka disembunyikan di sekitar kawasan Gunung Kawi, Jawa Timur.

**Output**  
<img width="685" height="136" alt="Screenshot 2026-03-25 021310" src="https://github.com/user-attachments/assets/b36ffbeb-6776-47ea-94d5-ecf915643338" />

4 baris data koordinat yang masing-masing mewakili satu titik lokasi ekspedisi. Node_001 adalah Titik Berak Paman Mas Mba dengan koordinat latitude -7.920000 dan longitude 112.450000, node_002 adalah Basecamp Mas Fuad dengan koordinat latitude -7.920000 dan longitude 112.468100, node_003 adalah Gerbang Dimensi Keputih dengan koordinat latitude -7.937960 dan longitude 112.468100, dan node_004 adalah Tembok Ratapan Keputih dengan koordinat latitude -7.937960 dan longitude 112.450000.

<img width="576" height="62" alt="Screenshot 2026-03-25 021350" src="https://github.com/user-attachments/assets/319efd1a-f80d-4b3b-bdab-03697b36d80a" />

Nilai latitude pusat -7.9289800000 diperoleh dari rata-rata latitude node_001 (-7.920000) dan node_003 (-7.937960), sedangkan nilai longitude pusat 112.4590500000 diperoleh dari rata-rata longitude node_001 (112.450000) dan node_003 (112.468100).

**Kendala**  
Tidak ada kendala 

</details>

<details>
<summary>Soal 3</summary>

**Penjelasan**  
Pertama buat file kost_slebew.sh dan fetup ftruktur folder - file

```awk
#!/bin/bash

# --- PATH ABSOLUT (penting untuk cron) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB="$SCRIPT_DIR/data/penghuni.csv"
LOG="$SCRIPT_DIR/log/tagihan.log"
REKAP="$SCRIPT_DIR/rekap/laporan_bulanan.txt"
SAMPAH="$SCRIPT_DIR/sampah/history_hapus.csv"

fungsi_tambah_penghuni() { ... }
fungsi_hapus_penghuni()  { ... }
fungsi_tampilkan_daftar(){ ... }
fungsi_update_status()   { ... }
fungsi_laporan_keuangan(){ ... }
fungsi_kelola_cron()     { ... }
fungsi_check_tagihan()   { ... }  # dipanggil oleh cron

# Jika dipanggil dengan argumen --check-tagihan
if [[ "$1" == "--check-tagihan" ]]; then
    fungsi_check_tagihan
    exit 0
fi

# Loop menu utama
while true; do
    tampilkan_menu_utama
    read -p "Enter option [1-7]: " pilihan
    case $pilihan in
        1) fungsi_tambah_penghuni ;;
        2) fungsi_hapus_penghuni ;;
        3) fungsi_tampilkan_daftar ;;
        4) fungsi_update_status ;;
        5) fungsi_laporan_keuangan ;;
        6) fungsi_kelola_cron ;;
        7) echo "Terima kasih!"; exit 0 ;;
        *) echo "Pilihan tidak valid!" ;;
    esac
done
```
DI bagian ini definisi variabel path menggunakan SCRIPT_DIR yang diambil secara  dari lokasi script agar cron tetap bisa menemukan file pendukungnya. Dari SCRIPT_DIR dibentuk variabel DB, LOG, REKAP, dan SAMPAH yang menunjuk ke file CSV, log, rekap, dan arsip.

```awk
tampilkan_menu_utama() {
    clear
    echo "========================================="
    echo "      SISTEM MANAJEMEN KOST SLEBEW"
    echo "========================================="
    echo " ID | OPTION"
    echo "-----------------------------------------"
    echo "  1 | Tambah Penghuni Baru"
    echo "  2 | Hapus Penghuni"
    echo "  3 | Tampilkan Daftar Penghuni"
    echo "  4 | Update Status Penghuni"
    echo "  5 | Cetak Laporan Keuangan"
    echo "  6 | Kelola Cron (Pengingat Tagihan)"
    echo "  7 | Exit Program"
    echo "========================================="
}
```

Fungsi ini membersihkan layar dengan clear dan menampilkan 7 opsi menu , fungsi ini dipanggil dengan while true loop.

```awk
fungsi_tambah_penghuni() {
    clear
    echo "========================================="
    echo "           TAMBAH PENGHUNI"
    echo "========================================="

    # Input Nama
    read -p "Masukkan Nama: " nama
    # (validasi: tidak boleh kosong)

    # Input Kamar — validasi UNIK
    while true; do
        read -p "Masukkan Kamar: " kamar
        # Cek apakah kamar sudah ada di CSV (kolom 2)
        if awk -F',' -v k="$kamar" 'NR>1 && $2==k {found=1} END {exit !found}' "$DB"; then
            echo "[!] Kamar $kamar sudah ditempati. Pilih kamar lain."
        else
            break
        fi
    done

    # Input Harga Sewa — validasi angka positif
    while true; do
        read -p "Masukkan Harga Sewa: " harga
        if [[ "$harga" =~ ^[0-9]+$ ]] && [ "$harga" -gt 0 ]; then
            break
        else
            echo "[!] Harga harus angka positif."
        fi
    done

    # Input Tanggal — validasi format & tidak boleh masa depan
    while true; do
        read -p "Masukkan Tanggal Masuk (YYYY-MM-DD): " tanggal
        # Cek format regex
        if [[ ! "$tanggal" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            echo "[!] Format tanggal salah."
            continue
        fi
        # Cek tidak melebihi hari ini
        today=$(date +%Y-%m-%d)
        if [[ "$tanggal" > "$today" ]]; then
            echo "[!] Tanggal tidak boleh melebihi hari ini."
        else
            break
        fi
    done

    # Input Status — validasi Aktif/Menunggak (case-insensitive)
    while true; do
        read -p "Masukkan Status Awal (Aktif/Menunggak): " status_raw
        status_lower=$(echo "$status_raw" | tr '[:upper:]' '[:lower:]')
        if [[ "$status_lower" == "aktif" ]]; then
            status="Aktif"; break
        elif [[ "$status_lower" == "menunggak" ]]; then
            status="Menunggak"; break
        else
            echo "[!] Status harus Aktif atau Menunggak."
        fi
    done

    # Simpan ke CSV
    echo "$nama,$kamar,$harga,$tanggal,$status" >> "$DB"
    echo ""
    echo "[√] Penghuni \"$nama\" berhasil ditambahkan ke Kamar $kamar dengan status $status."
    read -p "Tekan [ENTER] untuk kembali ke menu..."
}
```

Fungsi ini menerima input Nama, Kamar, Harga Sewa, Tanggal Masuk, dan Status. Setiap input divalidasi dan kamar dicek keunikannya dengan AWK, harga dicek menggunakan regex angka positif, tanggal dicek format dan tidak boleh masa depan, serta status dicek case-insensitive.

```awk
fungsi_hapus_penghuni() {
    clear
    echo "========================================="
    echo "           HAPUS PENGHUNI"
    echo "========================================="
    read -p "Masukkan nama penghuni yang akan dihapus: " nama

    # Cek apakah nama ada di database
    baris=$(awk -F',' -v n="$nama" 'NR>1 && $1==n' "$DB")

    if [[ -z "$baris" ]]; then
        echo "[!] Penghuni \"$nama\" tidak ditemukan."
    else
        tanggal_hapus=$(date +%Y-%m-%d)
        # Arsipkan ke history_hapus.csv (tambah kolom TanggalHapus)
        echo "$baris,$tanggal_hapus" >> "$SAMPAH"
        # Hapus dari database utama
        awk -F',' -v n="$nama" '$1 != n' "$DB" > /tmp/penghuni_tmp.csv
        mv /tmp/penghuni_tmp.csv "$DB"
        echo "[√] Data penghuni \"$nama\" berhasil diarsipkan ke sampah/history_hapus.csv dan dihapus dari sistem."
    fi

    read -p "Tekan [ENTER] untuk kembali ke menu..."
}
```

Fungsi ini mencari nama penghuni di CSV menggunakan AWK. Jika ditemukan, datanya terlebih dahulu diarsipkan ke history_hapus.csv dengan tambahan kolom tanggal hapus, baru kemudian dihapus dari database utama menggunakan AWK filter.

```awk
fungsi_tampilkan_daftar() {
    clear
    echo "========================================="
    echo "      DAFTAR PENGHUNI KOST SLEBEW"
    echo "========================================="

    awk -F',' '
    BEGIN {
        printf " %-3s | %-15s | %-5s | %-12s | %-10s\n", "No", "Nama", "Kamar", "Harga Sewa", "Status"
        print "-----------------------------------------"
        aktif=0; menunggak=0; no=0
    }
    NR>1 {
        no++
        # Format harga dengan titik ribuan
        harga = $3
        # Format Rp dengan titik (awk tidak ada printf dengan titik, pakai sprintf manual atau pipe ke numfmt)
        printf " %-3s | %-15s | %-5s | Rp%-10s | %-10s\n", no, $1, $2, harga, $5
        print "-----------------------------------------"
        if ($5 == "Aktif") aktif++
        else menunggak++
    }
    END {
        printf "\n Total: %d penghuni | Aktif: %d | Menunggak: %d\n", no, aktif, menunggak
        print "========================================="
    }
    ' "$DB"

    read -p "Tekan [ENTER] untuk kembali ke menu..."
}
```

Fungsi ini menggunakan AWK untuk membaca CSV dan mencetak tabel. BEGIN mencetak header, setiap baris data (setelah NR > 1) dicetak dengan nomor urut otomatis, dan blok END mencetak ringkasan total penghuni, jumlah Aktif, dan jumlah Menunggak.

```awk
fungsi_update_status() {
    clear
    echo "========================================="
    echo "           UPDATE STATUS"
    echo "========================================="
    read -p "Masukkan Nama Penghuni: " nama

    # Cek nama ada
    if ! awk -F',' -v n="$nama" 'NR>1 && $1==n {found=1} END {exit !found}' "$DB"; then
        echo "[!] Penghuni \"$nama\" tidak ditemukan."
        read -p "Tekan [ENTER] untuk kembali..."; return
    fi

    while true; do
        read -p "Masukkan Status Baru (Aktif/Menunggak): " status_raw
        status_lower=$(echo "$status_raw" | tr '[:upper:]' '[:lower:]')
        if [[ "$status_lower" == "aktif" ]]; then
            status="Aktif"; break
        elif [[ "$status_lower" == "menunggak" ]]; then
            status="Menunggak"; break
        else
            echo "[!] Status harus Aktif atau Menunggak."
        fi
    done

    # Update kolom 5 menggunakan AWK
    awk -F',' -v OFS=',' -v n="$nama" -v s="$status" '
        NR==1 {print; next}
        $1==n {$5=s}
        {print}
    ' "$DB" > /tmp/penghuni_tmp.csv
    mv /tmp/penghuni_tmp.csv "$DB"

    echo "[√] Status $nama berhasil diubah menjadi: $status"
    read -p "Tekan [ENTER] untuk kembali ke menu..."
}
```


Fungsi ini memverifikasi nama penghuni di database, lalu meminta input status baru dengan validasi case-insensitive. Update kolom dilakukan oleh AWK dengan -v OFS=',' yang mengganti nilai kolom ke-5 pada baris yang namanya cocok.

```awk
fungsi_laporan_keuangan() {
    clear

    # Hitung menggunakan AWK
    hasil=$(awk -F',' '
    NR>1 {
        if ($5=="Aktif") { total_aktif += $3; kamar++ }
        else { total_menunggak += $3 }
        daftar_menunggak = daftar_menunggak $1 " (Kamar " $2 ") - Rp" $3 "\n"
    }
    END {
        print "total_aktif=" total_aktif
        print "total_menunggak=" total_menunggak
        print "kamar=" kamar
        print "daftar=" daftar_menunggak
    }
    ' "$DB")

    eval "$hasil"

    # Tampilkan
    echo "========================================="
    echo "    LAPORAN KEUANGAN KOST SLEBEW"
    echo "========================================="
    echo " Total pemasukan (Aktif)  : Rp$total_aktif"
    echo " Total tunggakan          : Rp$total_menunggak"
    echo " Jumlah kamar terisi      : $kamar"
    echo "-----------------------------------------"
    echo " Daftar penghuni menunggak:"
    if [[ -z "$daftar" ]]; then
        echo "   Tidak ada tunggakan."
    else
        echo -e "$daftar"
    fi
    echo "========================================="

    # Simpan ke file rekap
    {
        echo "LAPORAN KEUANGAN KOST SLEBEW"
        echo "Tanggal: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Total pemasukan (Aktif)  : Rp$total_aktif"
        echo "Total tunggakan          : Rp$total_menunggak"
        echo "Jumlah kamar terisi      : $kamar"
    } > "$REKAP"

    echo "[√] Laporan berhasil disimpan ke rekap/laporan_bulanan.txt"
    read -p "Tekan [ENTER] untuk kembali ke menu..."
}
```

Bagian ini menghitung total pemasukan Aktif, total tunggakan, jumlah kamar terisi, dan daftar penghuni menunggak dalam satu pass. Hasilnya dikembalikan format key=value lalu di-eval menjadi variabel Bash dan disimpan ke laporan_bulanan.txt.


```awk
fungsi_kelola_cron() {
    while true; do
        clear
        echo "================================="
        echo "       MENU KELOLA CRON"
        echo "================================="
        echo " 1. Lihat Cron Job Aktif"
        echo " 2. Daftarkan Cron Job Pengingat"
        echo " 3. Hapus Cron Job Pengingat"
        echo " 4. Kembali"
        echo "================================="
        read -p "Pilih [1-4]: " sub

        case $sub in
            1)
                echo "--- Daftar Cron Job Pengingat Tagihan ---"
                crontab -l 2>/dev/null | grep "kost_slebew.sh --check-tagihan" || echo "(Tidak ada cron job aktif)"
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                ;;
            2)
                while true; do
                    read -p "Masukkan Jam (0-23): " jam
                    [[ "$jam" =~ ^[0-9]+$ ]] && [ "$jam" -ge 0 ] && [ "$jam" -le 23 ] && break
                    echo "[!] Jam tidak valid."
                done
                while true; do
                    read -p "Masukkan Menit (0-59): " menit
                    [[ "$menit" =~ ^[0-9]+$ ]] && [ "$menit" -ge 0 ] && [ "$menit" -le 59 ] && break
                    echo "[!] Menit tidak valid."
                done

                # Format 2 digit
                jam_fmt=$(printf "%02d" "$jam")
                menit_fmt=$(printf "%02d" "$menit")
                script_path="$(realpath "$SCRIPT_DIR/kost_slebew.sh")"

                # Hapus cron lama (overwrite), tambah baru
                crontab -l 2>/dev/null | grep -v "kost_slebew.sh --check-tagihan" > /tmp/crontab_tmp
                echo "$menit_fmt $jam_fmt * * * $script_path --check-tagihan" >> /tmp/crontab_tmp
                crontab /tmp/crontab_tmp
                rm /tmp/crontab_tmp

                echo "[√] Cron job berhasil didaftarkan pukul $jam_fmt:$menit_fmt"
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                ;;
            3)
                crontab -l 2>/dev/null | grep -v "kost_slebew.sh --check-tagihan" | crontab -
                echo "[√] Cron job pengingat tagihan berhasil dihapus."
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                ;;
            4)
                break
                ;;
            *)
                echo "[!] Pilihan tidak valid."
                sleep 1
                ;;
        esac
    done
}
```

Sub-menu ini menggunakan metode while true loop dengan 4 opsi. Opsi 1 menampilkan cron job dengan crontab -l | grep. Opsi 2 mendaftarkan jadwal baru sekaligus menghapus yang lama menggunakan grep -v agar hanya ada satu jadwal aktif. Opsi 3 menghapus cron job dengan grep -v | crontab -. Opsi 4 keluar sub-menu dengan break

**Output**  



**Kendala**  
Tidak ada kendala / [jelaskan kendala jika ada]

</details>

