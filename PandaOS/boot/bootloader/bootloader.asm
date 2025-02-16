[org 0x7C00]
[bits 16]

start:
    ; Configuração inicial
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Modo de vídeo 80x25
    mov ax, 0x0003
    int 0x10

    ; Mostrar tela de carregamento
    call show_loading_screen
    call show_system_info

    ; Esperar pressionar tecla
    xor ax, ax
    int 0x16

    ; Mostrar informações do criador
    call show_creator_info

    ; Esperar pressionar tecla novamente
    xor ax, ax
    int 0x16

    ; Carregar kernel
    jmp load_kernel

show_loading_screen:
    ; Barra de progresso
    mov cx, 30
    mov dh, 12
    mov dl, 25
.loading_loop:
    mov ah, 0x02
    xor bh, bh
    int 0x10
    
    mov ax, 0x0E2E
    int 0x10
    
    inc dl
    call delay
    loop .loading_loop
    ret

show_system_info:
    ; Mensagem do sistema
    mov si, sys_info
    call print_color_msg
    ret

show_creator_info:
    ; Mensagens de contato
    mov si, con_msg01
    call print_color_msg
    mov si, con_msg02
    call print_color_msg
    mov si, con_msg03
    call print_color_msg
    mov si, con_msg04
    call print_color_msg
    mov si, con_msg05
    call print_color_msg
    ret

print_color_msg:
    lodsb
    test al, al
    jz .done
    
    mov bl, al      ; Cor/atributo
    lodsb
.print_char:
    mov ah, 0x0E
    int 0x10
    lodsb
    test al, al
    jnz .print_char
.done:
    mov ax, 0x0E0D  ; Nova linha
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

delay:
    push cx
    mov cx, 0x0FFF
.delay_loop:
    nop
    loop .delay_loop
    pop cx
    ret

load_kernel:
    ; Carregar kernel do disco
    mov ah, 0x02    ; Correção aqui: ag → ah
    mov al, 1       ; Número de setores
    mov ch, 0       ; Cylinder
    mov cl, 2       ; Setor
    mov dh, 0       ; Head
    mov bx, 0x1000
    mov es, bx
    xor bx, bx
    int 0x13
    
    jc disk_error
    jmp 0x1000:0x0000

disk_error:
    mov si, error_msg
    call print_color_msg
    jmp $

; Dados
sys_info db 0x0F, "PANDA-OS v0.1", 0x0D, 0x0A
         db 0x0F, "x86-64 | Modo Real", 0x0D, 0x0A
         db 0x0F, "640KB RAM | 1MB Ext", 0x0D, 0x0A
         db 0x0F, "Carregando kernel...", 0

con_msg01 db 0x0A,0x0F, ' Midias Sociais do criador: ',0x0F, 0
con_msg02 db 0xFE, ' Instagram: @01pandal10', 0
con_msg03 db 0x08, ' YouTube: @X86BinaryGhost', 0
con_msg04 db 0x02, ' Email: amandasyscallinjector@gmail.com', 0
con_msg05 db ' GitHub: panda12332145', 0x03, 0

error_msg db 0x4F, "Erro no kernel!", 0

; Assinatura de boot
times 510-($-$$) db 0
dw 0xAA55