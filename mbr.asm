org 0x1000

start:

	xor ax , ax 
	mov ss , ax
	mov sp , 0x7c00

	mov ds , ax 
	mov es , ax

	mov si , 0x7c00
	mov di , 0x1000

	cld
	rep movsb

	push Relocated_Code
	push 0x00
	retf 

Relocated_Code:
	sti 
	mov [Drive_Index] , dl
	mov cx , 0x4
	mov bp ,0x11be

Is_Active_Partition:
	cmp [bp] , 0x80
	je Active_Partition_Found
	add bp ,0x10
	loop Is_Active_Partition
	jz No_Active_Partition
	int 0x18
	hlt
 
Active_Partition_Found:
Check_Ext_Present:
	mov ah , 0x41
	mov bx , 0x55aa
	int 0x13

	jb N0_Ext_Read
Ext_Read:
	mov ah , 0x42
	mov dl , byte [Drive_Index]
	mov si ,Disk_Address_Packet
	int 0x13

	jb Error_Read
	jmp Jump_To_Loaded_Sector

N0_Ext_Read:

	mov ax , 0x201
	mov bx , 0x7c00
	mov dl , [Drive_Index]
	mov dh , byte [bp+1]
	mov cl , byte [bp+2]
	mov ch , byte [bp+3]
	int 0x13
	jb Error_Read
	jmp Jump_To_Loaded_Sector

Jump_To_Loaded_Sector:
	jmp 0x0:0x7c00 

Error_Read:
	mov ax ,[Error_Read_String]
	jmp Print_String
	int 0x18

No_Active_Partition:
	mov ax ,[No_Active_Partition_String]
	jmp Print_String
	int 0x18

Print_String:
	xor ah , ah
	mov si , ax

	Load_Next_Char:

	lodsb
	cmp al , 0x00
	jz End_Of_String:
	mov bx , 0x0007
	mov ah , 0x0e
	int 0x10

End_Of_String:
	ret

	hlt 

No_Active_Partition_String db "There is no active partition",0x0

Error_Read_String db "Error when Disk reading",0x0
	
Drive_Index db 0x00

align 4

Disk_Address_Packet:
	
	.size       			db 0x10
	.unused 				db 0x00
	.Number_Sector_To_read 	dw 0x01
	.Offset 				dw 0x7c00
	.Segment 				dw 0x00 
	.Lba_To_Read			dd 0x00
							dd 0x00 
times 0x1be -($-$$) db 0x00

Entry_1:
	
	.Active db 0x00
	.CHS    db 0x00
			db 0x00
			db 0x00
	.Sys_Id db 0x00
	.End_CHS
			db 0x00
			db 0x00
			db 0x00
	.LBA	dd 0x00
	.Size   dd 0x00
			
Entry_2:
	
	.Active db 0x00
	.CHS    db 0x00
			db 0x00
			db 0x00
	.Sys_Id db 0x00
	.End_CHS
			db 0x00
			db 0x00
			db 0x00
	.LBA	dd 0x00
	.Size   dd 0x00
	
Entry_3:
	
	.Active db 0x00
	.CHS    db 0x00
			db 0x00
			db 0x00
	.Sys_Id db 0x00
	.End_CHS
			db 0x00
			db 0x00
			db 0x00
	.LBA	dd 0x00
	.Size   dd 0x00

Entry_4:
	
	.Active db 0x00
	.CHS    db 0x00
			db 0x00
			db 0x00
	.Sys_Id db 0x00
	.End_CHS
			db 0x00
			db 0x00
			db 0x00
	.LBA	dd 0x00
	.Size   dd 0x00

Sign dw 0xaa55 