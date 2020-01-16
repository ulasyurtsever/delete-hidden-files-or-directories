
# Delete hidden files or directories
This script is used to delete hidden files or directories in USB drives.
 
Bu script, MAC işletim sisteminde, her bir dosya için oluşturulan meta dosyalarını (.dosya_adı) silmek amacıyla hazırlanmış bir applescripttir.
 
MAC işletim sisteminde, hazırladığınız bir dosyayı USB sürücüye kopyalayıp Windows işletim sisteminde açtığınız zaman, her bir dosyanın yanında aynı isimde **nokta (.)** uzantılı bir dosya daha olmaktadır. Özellikle MP3 oynatıcılarda bu gizli dosyalar sorun oluşturabilmektedir. Bu dosyaları tek tek silmek yerine applescript ile silebilirsiniz. Ayrıca bu script dosyasını Apple >> Automator programı yardımıyla uygulama haline getirip MAC işletim sisteminde kullanabilirsiniz. Veya uygulama haline getirilmiş **DeleteHiddenFilesDirectories.app** dosyasını Applications klasörüne indirip direk çalıştırabilirsiniz.

Bu scripti kendi işimi görmek için hızlıca hazırladığımdan dolayı kodlar optimize edilmemiştir. Fakat sorunsuz çalışmaktadır.

Silinecek dosya veya klasör seçenekleri:  
1-All hidden files (.file_name*) : Tüm gizli dosyaları silecektir.  
2-All hidden directory (.directory_name*) : Tüm gizli olan klasörleri silecektir.  
3-Folder (.Spotlight*) : Spotlight ile başlayan gizli klasör silinecektir.  
4-Folder (.fseventsd*) : fseventsd ile başlayan gizli klasör silinecektir.  
5-Folder (.Trashes*) : Trashes gizli klasörü silinecektir.  
6-Folder (System Volume Information) : System Volume Information klasörü silinecektir.  
