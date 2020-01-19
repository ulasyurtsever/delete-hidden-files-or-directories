on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on process_usb_device(i, USB)
	set serial_num to ""
	set current_item to item i of USB
	repeat until current_item = ""
		set i to i + 1
		set current_item to item i of USB
		if current_item contains "Mount point:" then
			set serial_num to text ((offset of ": " in current_item) + 2) through -1 of current_item
		end if
	end repeat
	return serial_num
end process_usb_device

--Removable Media: Yes olan USB sürücüler listesi oluşturuluyor
set USB_Drives to {}
set USB to paragraphs of (do shell script "system_profiler SPUSBDataType -detailLevel basic")
repeat with i from 1 to (count of USB)
	if item i of USB contains "Removable Media: Yes" then
		set xxx to process_usb_device(i, USB)
		if xxx is not equal to ("") then
			set xxx to replace_chars(xxx, "/Volumes/", "")
			set USB_Drives to USB_Drives & xxx
		end if
	end if
end repeat
set USB_Number to (count of USB_Drives)

if USB_Number = 0 then
	display dialog ("Please check USB drive. No USB drive was found. 

Bilgisayarınıza bağlı bir USB sürücüsü bulunamamıştır.") with title ("Delete hidden files or directories in USB drive") with icon stop buttons {"Done"} default button "Done"
	return
end if

if USB_Number > 1 then
	set secim to (choose from list USB_Drives with title ("Select USB Driver") with prompt "Select the one USB driver from the list below.

Aşağıdaki listeden bir USB sürücüsü seçiniz." OK button name "Continue" cancel button name "Cancel" default items {xxx}) as text
	
	if secim is equal to ("false") then
		return
	end if
else
	set secim to xxx
end if

set islem to ""
set kontrol to ""
set usb_name to ""

repeat while islem = ""
	set islem to "bitti"
	
	set sonuc to display dialog ("Selected USB drive: " & secim & "
	
Seçilen USB sürücüsü: " & secim) with title ("Delete hidden files or directories in USB drive") with icon caution buttons {"About...", "Cancel", "Continue"} default button "Continue"
	set usb_name to secim
	set buton_name to the button returned of sonuc
	
	if buton_name = "About..." then
		display dialog ("ULAŞ YURTSEVER 
	
	Websites: http://www.ulasyurtsever.com 
	Email: ulasyurtsever@gmail.com 
	LinkedIn: https://www.linkedin.com/in/ulasyurtsever/ 
	") with title ("About...") buttons {"Done"} default button "Done"
		set islem to ""
	else
		--Mount unmount işlemleri için bilgiler alınıyor...
		try
			tell application "Finder"
				if disk usb_name exists then
					set kontrol to "var"
				end if
			end tell
			if kontrol = "var" then
				set usb_name2 to replace_chars(usb_name, " ", "\\ ")
				set usblongname to do shell script "(diskutil list | grep " & usb_name2 & ")"
				set usbname to text -7 through -1 of usblongname
				set kontrol to ""
			else
				display dialog ("Please check USB drive named. No USB drive with this name was found. This application has case sensitivity. 

Lütfen USB sürücü adını kontrol ediniz. Bu isimde bir USB sürücüsü bulunamamıştır. Uygulama büyük/küçük harfe duyarlıdır.") with title ("Delete hidden files or directories in USB drive") with icon stop buttons {"Done"} default button "Done"
				set islem to ""
			end if
			
		on error errStr number errorNumber
			if errorNumber = 2 then
				display dialog ("Please enter the USB drive name.
			
Lütfen USB sürücü adını giriniz.") with title ("Delete hidden files or directories in USB drive") with icon stop buttons {"Done"} default button "Done"
				
			end if
			if errorNumber = 1 then
				display dialog ("Please check USB drive named. No USB drive with this name was found. This application has case sensitivity. 

Lütfen USB sürücü adını kontrol ediniz. Bu isimde bir USB sürücüsü bulunamamıştır. Uygulama büyük/küçük harfe duyarlıdır.") with title ("Delete hidden files or directories in USB drive") with icon stop buttons {"Done"} default button "Done"
			end if
			set islem to ""
		end try
	end if
end repeat

--Silineceklerin neler olacağını kullanıcının seçeceği ekran geliyor...
set input to (choose from list {"01-All hidden files (.file_name*),", "02-All hidden directory (.directory_name*),", "03-Folder (.Spotlight*),", "04-Folder (.fseventsd*),", "05-Folder (.Trashes*),", "06-Folder (System Volume Information),", "07-Folder (.AppleDouble),", "08-File (.DS_Store),", "09-File (Thumbs.ini),", "10-File (Desktop.ini),", "11-Folder ($Recycle.bin),"} with title "Delete hidden files/directories in USB drive" with prompt "Select the ones you want to delete from the list below (you can multiple selections).

Aşağıdaki listeden silmek istediklerinizi seçiniz (çoklu seçim yapabilirsiniz...)." default items {"01-All hidden files (.file_name*),", "03-Folder (.Spotlight*),", "04-Folder (.fseventsd*),", "05-Folder (.Trashes*),", "06-Folder (System Volume Information),"} OK button name "Continue" cancel button name "Cancel" with multiple selections allowed) as text

if input is not equal to ("false") then
	set yol to "/Volumes/" & usb_name2 & "/."
	
	tell application "Finder"
		if disk usb_name exists then
			set input to text 1 thru -2 of input --son karakter olan (,) siliniyor. 
			set AppleScript's text item delimiters to {","}
			set delimitedList to every text item of input
			repeat with itemlist in delimitedList
				if itemlist is not equal to null then
					set islem_no to text 2 through 1 of itemlist --ilk iki karakter okunuyor.
				else
					set islem_no to "0"
				end if
				if islem_no is equal to ("01") then
					try
						do shell script "find " & yol & " -depth -type f -name '.*' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("02") then
					try
						do shell script "find " & yol & " -depth -type d -name '.*' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("03") then
					try
						do shell script "find " & yol & " -depth -name '.Spotlight*' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("04") then
					try
						do shell script "find " & yol & " -depth -name '.fseventsd*' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("05") then
					try
						do shell script "find " & yol & " -depth -name '.Trashes*' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("06") then
					try
						do shell script "find " & yol & " -depth -name 'System Volume Information' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("07") then
					try
						do shell script "find " & yol & " -depth -name '.AppleDouble' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("08") then
					try
						do shell script "find " & yol & " -depth -name '.DS_Store' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("09") then
					try
						do shell script "find " & yol & " -depth -name 'Thumbs.ini' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("10") then
					try
						do shell script "find " & yol & " -depth -name 'Desktop.ini' -exec rm -Rf {} ';'"
					end try
				end if
				if islem_no is equal to ("11") then
					try
						do shell script "find " & yol & " -depth -name '$Recycle.bin' -exec rm -Rf {} ';'"
					end try
				end if
			end repeat
			set sonuc to display dialog ("Hidden files/directories deleted. Unmount the USB drive?
			
Seçtiğiniz dosyalar/klasörler silinmiştir. USB sürücüsü çıkarılsın mı?") with title ("Delete hidden files or directories in USB drive") with icon stop buttons {"Yes", "No"} default button "Yes"
			set button_name to button returned of sonuc
			if button_name = "Yes" then
				do shell script "diskutil unmount /dev/" & usbname
				display dialog ("USB drive unmounted") with title ("Delete hidden files or directories in USB drive") with icon note buttons {"Done"} default button "Done"
			end if
		else
			display dialog ("No USB drive named '" & usb_name & "'") with title ("Delete hidden files or directories in USB drive") with icon stop buttons {"Done"} default button "Done"
		end if
	end tell
end if
