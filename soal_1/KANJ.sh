BEGIN {
    FS = ","
    if (soal != "a" && soal != "b" && soal != "c" && soal != "d" && soal != "e") {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f file.sh data.csv a"
        exit
    }
}

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

