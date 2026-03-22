#!/bin/bash


# ================================================
# SISTEM MANAJEMEN KOST SLEBEW
# ================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB="$SCRIPT_DIR/data/penghuni.csv"
LOG="$SCRIPT_DIR/log/tagihan.log"
REKAP="$SCRIPT_DIR/rekap/laporan_bulanan.txt"
SAMPAH="$SCRIPT_DIR/sampah/history_hapus.csv"


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

fungsi_check_tagihan() {
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Cari semua penghuni dengan status Menunggak
    awk -F',' -v ts="$timestamp" '
    NR>1 && $5=="Menunggak" {
        printf "[%s] TAGIHAN: %s (Kamar %s) - Menunggak Rp%s\n", ts, $1, $2, $3
    }
    ' "$DB" >> "$LOG"
}

# ================================================
# ENTRY POINT
# ================================================

# Jika dipanggil dengan argumen --check-tagihan (oleh cron)
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
        *) echo "[!] Pilihan tidak valid!"; sleep 1 ;;
    esac
done
