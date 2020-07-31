docker-compose exec machado python manage.py load_relations_ontology --file data/sample/ontologies/ro.obo
docker-compose exec machado python manage.py load_sequence_ontology --file data/sample/ontologies/so.obo
#docker-compose exec machado python manage.py load_gene_ontology --file data/sample/ontologies/go.obo --cpu 2
docker-compose exec machado python manage.py insert_organism --genus Arabidopsis --species thaliana
docker-compose exec machado python manage.py load_fasta --file data/sample/genomes/Athaliana_167_TAIR9.chrM.fa --soterm chromosome --organism 'Arabidopsis thaliana'
docker-compose exec machado python manage.py load_gff --file data/sample/genomes/Athaliana_167_TAIR10.chrM.gff3.gz --organism 'Arabidopsis thaliana' --cpu 2
docker-compose exec machado python manage.py load_feature_annotation --file data/sample/genomes/Athaliana_167_TAIR10.defline.ChrM.txt --soterm mRNA --cvterm display
docker-compose exec machado python manage.py load_feature_annotation --file data/sample/genomes/Athaliana_167_TAIR10.defline.ChrM.txt --soterm polypeptide --cvterm display
docker-compose exec machado python manage.py rebuild_index
