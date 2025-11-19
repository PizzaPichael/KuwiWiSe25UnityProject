from multiprocessing import process
from fastavro import reader

file_path = "C:/Users/Lenovo/Downloads/20170109_16_anonymized.avro/20170109_16_anonymized.avro"

with open(file_path, "rb") as fo:
    avro_reader = reader(fo)
    for record in avro_reader:
        # Verarbeite jeden Datensatz hier
        process(record)