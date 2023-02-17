segment .data
	msg1 db "nhap so dau tien:"
	len1 equ $- msg1
	msg2 db "nhap so thu hai:"
	len2 equ $- msg2
	temp db "00000000000"			; temp variable use to reverse the inputed number
	msg3 db "tong cua hai so tren la:"
	len3 equ $- msg3

segment .bss
	num1 resb 11
	num1_rev resb 11			; num1_rev chứa str bị đảo ngược của num1
	num2_rev resb 11			;num2_rev chứa str bị đảo ngược của num2
	num2 resb 11
	total resb 11
segment .text
	global _start
_start:
	mov ecx,msg1					;dịa chi  msg1
	mov edx,len1					; độ dài msg1
	call print					; gọi hàm print
	
	mov ecx,num1					; địa chỉ num1
	mov edx,11					; độ dài của num1 
	call scan					;gọi hàm san
	
	mov esi,eax-1					; sau khi scan input vào thì thanh eax sẽ lưu độ dài cua string vua nhap
	dec esi						; esi se la kieu nhu offset vi tri cua các số va nó sẽ chỉ về số hàng đơn vị
	mov edi,0
	mov ecx,eax-1					; ecx la counter de loop ham rev_num1 can loop no dung bang do dai cua str
	dec ecx
	clc
rev_num1:
	mov al,[num1+esi-1]				;luu gia tri cua tung chu so bat dau tu hang don vi vao thanh ghi al
	add al,"0"
	aaa						; adjust after addition	
	pushf
	or al,0x30					;0x30="0"
	popf
	
	mov [num1_rev+edi],al				; luu gia tri cua thanh ghi al vao num1_rev bat dau tu vi ti dau tien de dao nguoc chuoi
	dec esi						; dùng thanh esi để chỉ đến hàng tiếp theo kiểu hàng đơn vị -> hàng chục->hàng trăm
	inc edi						; edi sẽ là thanh ghi chỉ đển các vị trí của num1_rev từ trái qua phải
	loop rev_num1					; sau khi kết thúc loop  rev_num1 thì nó sẽ như này VD:num1=123456789 num1_rev=987654321
	
	mov ecx,msg2					; địa chỉ hàm msg2
	mov edx,len2					;độ dài của msg2
	call print					; gọi hàm print
	
	mov ecx,num2					;địa chỉ của num2
	mov edx,11					; độ dài muốn scan 
	call scan					; gọi hàm scan
	
	mov esi,eax-1					;các bước i hệt với rev_num1 
	dec esi
	mov edi,0
	mov ecx,eax-1
	dec ecx
	clc
rev_num2:
	mov al,[num2+esi-1]
	add al,"0"
	aaa
	pushf
	or al,0x30
	popf
	
	mov [num2_rev+edi],al
	dec esi
	inc edi
	loop rev_num2					; sau khi hoàn thành num2=1234 num2_rev=4321
	
	mov ecx,10					; ecx sẽ là counter loop và chúng ta cần loop nó 10 lần vì độ dài lớn nhất của một chuỗi có thể là 10
	mov esi,0					;esi là offset chỉ đến vị trí đầu tiên của num1_rev và num2_rev 
	mov edi,9					;edi là offset chỉ đến vị trí cuối cùng của total
	clc
add_loop:
	mov al,[num1_rev+esi]				; sau khi dao nguoc chuoi nhap vao thi minh cong chuoi vo
	adc al,[num2_rev+esi]				; adc la addd carry neu nhu co phep du thi no se cong vo hang tiesp theo
	aaa						;adjust after addition
	pushf
	or al,0x30
	popf
	
	mov [total+edi],al				; lưu giá trị của thanh al vào vị total bắt đầu từ vị trí hàng đươn vị
	dec edi						; giảm edi lần lượt để có thể lưu vào các vị trí tiếp theo của total vd hàng đơn vị -> hàng chục ->hàng trăm	
	inc esi						; tăng thanh esi để chỉ đến các vị trí tiếp theo của num1_rev và num2_rev	
	loop add_loop
	
	
	;print kết quả	
	mov edx,len3					; đọ dài cảu msg3
	mov ecx,msg3					; đại chỉ của msg3
	call print					; gọi hàm print	
	mov edx,10					; đọ dài của cần in total
	mov ecx,total					; địa chỉ của total
	call print					; gọi hàm print
	;exit
	mov eax,0x1					;EAX=1 sẽ gọi hàm exit()	
	int 0x80					; syscall trong x86_64bit
	

print:
	mov eax,0x4					;EAX=4 gọi hàm WRITE()
	mov ebx,0x1					; standard output
	int 0x80					; syscall
	ret						; trả về và tiếp tục chương trình

scan:
	mov eax,3					; EAX=3 gọi hàm READ()
	mov ebx,0					; standard input
	int 0x80					; syscall
	ret						;trả về và tiếp tục chương trình
