# 🚀 PandaOS Documentation

> **PandaOS** é um sistema operacional **100% from-scratch** focado em modularidade, desempenho e flexibilidade.  Este repositório documenta a arquitetura completa, os fluxos de trabalho e os componentes essenciais, desde o bootloader até o kernel, drivers, e ferramentas de build e testes.

---

## 📑 Sumário

- [Introdução](#introdução-)
- [Estrutura de Diretórios](#estrutura-de-diretórios-)
- [Fluxo de Trabalho e CI/CD](#fluxo-de-trabalho-e-cicd-)
- [O Bootloader Principal](#o-bootloader-principal-)
- [Kernel e Subsistemas](#kernel-e-subsistemas-)
- [Drivers e Bibliotecas](#drivers-e-bibliotecas-)
- [Sistema de Build e Testes](#sistema-de-build-e-testes-)
- [Considerações de Segurança e Futuras Melhorias](#considerações-de-segurança-e-futuras-melhorias-)
- [Fluxo de Trabalho em Mermaid](#fluxo-de-trabalho-em-mermaid-)
- [Considerações Finais](#considerações-finais-)

---
# ✨ Showcase Video
> _**Ainda não Disponivel**_

# ⚠️ Important
O PandaOS só funcionará no QEMU, para que possa ter operações e funções mais fáceis e legíveis.

## ✨ Introdução

O **PandaOS** é um sistema operacional desenvolvido do zero, projetado para ambientes **x86-64**. O projeto é **multilíngue** e utiliza:

- **Assembly (x86-64)** para operações de baixo nível 🚀
- **C/C++** para o kernel core e drivers de alta performance 💻
- **Pascal** para subsistemas críticos como o escalonador e IPC 🔧
- **Python** para scripts de automação e orquestração 🐍

Essa abordagem híbrida permite um controle preciso dos recursos do sistema, garantindo performance e segurança.

---

## 📂 Estrutura de Diretórios

A seguir, a árvore de diretórios do PandaOS, com descrições de cada componente:

```plaintext
/PandaOS
├── /boot
│   ├── mbr/
│   │   ├── mbr.asm                # Master Boot Record (x86-64 ASM)
│   │   └── partition_table.asm    # Tabela de partições primária
│   ├── bootloader/
│   │   ├── stage1.asm             # Bootloader estágio 1 (BIOS)
│   │   ├── stage2.c               # Bootloader estágio 2 (Modo protegido)
│   │   └── stage3.cpp             # Bootloader estágio 3 (Modo longo 64-bit)
│   └── config/
│       ├── boot.json              # Parâmetros de boot (ex: timeout, kernel path)
│       └── hardware_detect.json   # Configuração inicial de hardware
├── /kernel
│   ├── arch/
│   │   └── x86_64/
│   │       ├── entry.asm          # Entry point do kernel (ASM)
│   │       ├── gdt.asm            # Global Descriptor Table
│   │       ├── idt.asm            # Interrupt Descriptor Table
│   │       └── apic/              # Driver APIC (Advanced Programmable Interrupt Controller)
│   ├── core/
│   │   ├── kmain.cpp              # Ponto principal do kernel (C++)
│   │   ├── memory/
│   │   │   ├── pmm.c              # Physical Memory Manager (C)
│   │   │   └── vmm.cpp            # Virtual Memory Manager (C++)
│   │   ├── process/
│   │   │   ├── scheduler.pas      # Escalonador de processos (Pascal)
│   │   │   └── threads.c          # Gerenciamento de threads
│   │   ├── syscalls/
│   │   │   ├── syscalls.asm       # Syscalls de baixo nível (ASM)
│   │   │   └── syscalls_api.c     # API de syscalls para userland
│   │   └── fs/
│   │       ├── panda_fs.cpp       # Sistema de arquivos customizado
│   │       └── vfs.c              # Virtual File System
├── /drivers
│   ├── storage/
│   │   ├── ata.cpp                # Driver ATA (C++)
│   │   ├── nvme.asm               # Driver NVMe (ASM para performance)
│   │   └── fs_drivers/
│   │       ├── ext4.c             # Driver para sistemas externos (ex: EXT4)
│   │       └── fat32.pas          # Driver FAT32 (Pascal)
│   ├── video/
│   │   ├── vga.c                  # Driver VGA básico
│   │   ├── framebuffer.cpp        # Driver para framebuffer
│   │   └── gpu/
│   │       ├── nvidia.c           # Driver para GPUs NVIDIA
│   │       └── amd.asm            # Otimizações para AMD em ASM
│   ├── input/
│   │   ├── keyboard.c             # Driver de teclado (PS/2)
│   │   ├── mouse.cpp              # Driver de mouse
│   │   └── usb/
│   │       ├── usb_core.pas       # Core USB em Pascal
│   │       └── usb_hid.c          # Dispositivos HID USB
│   └── pci/
│       ├── pci_enum.c             # Enumeração de dispositivos PCI
│       └── pci_devices.json       # Database de IDs PCI
├── /lib
│   ├── libc/
│   │   ├── stdio.c                # printf, scanf, etc.
│   │   ├── stdlib.cpp             # malloc, free (C++)
│   │   └── math.pas               # Funções matemáticas (Pascal)
│   ├── libpanda/
│   │   ├── graphics.py           # Helpers gráficos em Python
│   │   └── sysutils.pas           # Utilitários de sistema em Pascal
│   └── firmware/
│       └── uefi/                  # Firmware UEFI (se aplicável)
├── /userland
│   ├── init/
│   │   └── init.c                # Processo init (primeiro processo userspace)
│   ├── shell/
│   │   ├── shell.cpp             # Shell principal (C++)
│   │   └── scripts/
│   │       ├── network.py        # Scripts de rede em Python
│   │       └── utils.pas         # Utilitários em Pascal
│   └── gui/
│       ├── window_manager.cpp    # Gerenciador de janelas
│       └── themes/
│           ├── default.json      # Tema padrão (JSON)
│           └── icons/
├── /config
│   ├── system/
│   │   ├── sysconfig.json        # Configuração do sistema
│   │   └── network.json          # Configurações de rede
│   └── users/
│       ├── root.json             # Configurações do root
│       └── permissions.pas       # Gerenciamento de permissões
├── /build
│   ├── toolchain/
│   │   ├── cross-compiler/       # Compilador cruzado x86_64-panda
│   │   └── linker_scripts/       # Scripts de linker para o kernel
│   ├── iso/                      # ISO gerada
│   └── logs/                     # Logs de compilação
├── /tests
│   ├── unit/
│   │   ├── memory_tests.c        # Testes de memória
│   │   └── syscall_tests.pas     # Testes de syscall em Pascal
│   ├── integration/
│   │   ├── hardware_tests.py     # Testes de hardware com Python
│   │   └── stress_tests.cpp      # Testes de estresse
│   └── qemu/                     # Configs para emulação
├── /docs
│   ├── specs/                    # Especificações técnicas
│   ├── man/                      # Manuais
│   └── api/                      # Documentação da API
└── /scripts
    ├── build.py                  # Script de build principal (Python)
    ├── deploy.sh                 # Deploy em hardware real
    └── tools/
        ├── partition_manager.pas # Gerenciador de partições
        └── kernel_debugger.cpp   # Debugger do kernel
```

Cada diretório foi estruturado para manter a **clareza** e a **modularidade** do projeto, facilitando a manutenção e a expansão contínua do sistema.

---

## 🔄 Fluxo de Trabalho e CI/CD

O desenvolvimento do PandaOS segue um fluxo de trabalho rigoroso, integrando práticas de CI/CD para garantir estabilidade e qualidade. Veja como o processo se desenvolve:

```mermaid
graph TD
    A[Planejamento] --> B[Desenvolvimento]
    B --> C{Seleção de Linguagem}
    C -->|Baixo Nível| D[Assembly x86-64]
    C -->|Kernel/Drivers| E[C/C++]
    C -->|Subsistemas| F[Pascal]
    C -->|Automação/Scripts| G[Python]
    
    D --> H[Bootloader/MBR]
    E --> I[Kernel Core]
    F --> J[IPC, Scheduler]
    G --> K[Scripts de Build]
    
    H --> L((Bootloader Compilado))
    I --> M((Kernel Binário))
    J --> N((Bibliotecas))
    K --> O((ISO Gerada))
    
    L --> P[Boot em QEMU]
    M --> P
    N --> P
    O --> P
    
    P --> Q{Testes}
    Q -->|Sucesso ✅| R[Deploy em HW]
    Q -->|Falha ❌| S[Depuração]
    S -->|GDB/Serial Debug| T[Correções]
    T --> B
    
    subgraph CI/CD
        U[Git] --> V[Branch Feature]
        V --> W[Build Noturno 🌙]
        W --> X[Testes Automatizados 🤖]
        X -->|Passou ✅| Y[Merge para Main]
        X -->|Falhou ❌| Z[Alertas por Email]
    end
    
    subgraph Documentação
        A2[Doxygen 📚] --> B2[Doc Técnica]
        C2[Sphinx ✨] --> D2[Manuais]
        E2[JSON Schemas 🛡️] --> F2[Config Validação]
    end
    
    Y --> AA[Release Engineer]
    AA --> AB[ISO Estável]
    AB --> AC[Deploy em Cloud ☁️]
    
    classDef focus fill:#f9f,stroke:#333;
    class P,Q,R,S focus;
```

Esse diagrama detalha as etapas desde o planejamento, desenvolvimento, seleção de linguagens, build, testes e até o deploy, com um fluxo contínuo de integração e entrega.

---

## 🔧 O Bootloader Principal

O bootloader é a primeira etapa de inicialização e é dividido em **três estágios** para contornar as limitações do ambiente de boot e preparar o sistema para o kernel em 64-bit:

### Fases do Bootloader

1. **Stage 1 (BIOS – Modo Real)**  
   - **Função:** Inicializa o sistema e prepara a transição para o modo protegido.  
   - **Implementação:** Em Assembly x86-64 (`mbr.asm`) 🚀

2. **Stage 2 (Modo Protegido 32-bit)**  
   - **Função:** Configura hardware básico e gerencia a memória.  
   - **Implementação:** Em C (`stage2.c`) 💻

3. **Stage 3 (Modo Longo 64-bit)**  
   - **Função:** Configura o ambiente de execução em 64-bit e transfere o controle para o kernel.  
   - **Implementação:** Em C++ (`stage3.cpp`) 🔧

### Exemplo de Código do Bootloader

```asm
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

; Funções de exibição e carregamento abaixo...
```

**Detalhes Importantes:**

- **Inicialização:** Configuração dos registradores e da pilha para garantir uma transição suave.
- **Modo de Vídeo:** Configuração do modo 80x25 para saída em texto.
- **Exibição:** Funções como `show_loading_screen` e `show_system_info` utilizam interrupções BIOS para exibir informações importantes.
- **Carregamento do Kernel:** Uso da interrupção `int 0x13` para ler setores do disco e transferir a execução ao kernel.

---

## ⚙️ Kernel e Subsistemas

Após o bootloader, o controle passa para o kernel, composto por diversos módulos críticos:

- **Entry Point e Inicialização:**  
  Arquivos em `arch/x86_64/` (ex.: `entry.asm`, `gdt.asm`, `idt.asm`) preparam o ambiente para o modo 64-bit.

- **Gerenciamento de Memória:**  
  Implementado por `pmm.c` (Physical Memory Manager) e `vmm.cpp` (Virtual Memory Manager).

- **Processos e Threads:**  
  O escalonador (`scheduler.pas`) e o gerenciamento de threads (`threads.c`) coordenam a execução paralela dos processos.

- **Syscalls:**  
  Implementadas em `syscalls.asm` e expostas em `syscalls_api.c`, permitindo a comunicação segura entre userland e kernel.

- **Sistema de Arquivos:**  
  Composto pelo `panda_fs.cpp` e `vfs.c`, garantindo organização e acesso aos dados.

---

## 🛠️ Drivers e Bibliotecas

Os drivers são desenvolvidos com foco em performance e compatibilidade:

- **Storage:**  
  Drivers ATA (`ata.cpp`) e NVMe (`nvme.asm`), além dos adaptadores para EXT4 e FAT32.

- **Vídeo e Interface:**  
  Drivers VGA, framebuffer e suporte a GPUs NVIDIA e AMD.

- **Entrada:**  
  Drivers para teclado, mouse e dispositivos USB (com implementações em Pascal e C).

- **Bibliotecas:**  
  A **libc** oferece funções padrão (como `printf` e `malloc`), enquanto o `libpanda` e outros utilitários em Python e Pascal suportam operações gráficas e de sistema.

---

## 📦 Sistema de Build e Testes

Para garantir a qualidade e integridade do PandaOS, adotamos:

- **Toolchain Personalizada:**  
  Compilador cruzado e scripts de linker (localizados em `/build/toolchain`).

- **ISO Gerada e Logs:**  
  A pasta `/build` armazena a ISO final e os logs de compilação.

- **Testes Abrangentes:**  
  Testes unitários, de integração e de estresse utilizando C, Pascal, Python e emulação via QEMU.

- **CI/CD Automatizada:**  
  Pipeline que inclui builds noturnos, testes automatizados e deploy controlado (com alertas e merges via Git).

---

## 🔒 Considerações de Segurança e Futuras Melhorias

- **Isolamento de Memória:**  
  Implementação de paginação de 4 níveis para garantir a integridade dos processos.

- **Sandboxing e Capabilities:**  
  Aplicações em userland são executadas em ambientes restritos, definidos por configurações JSON.

- **Modularidade:**  
  A estrutura permite a integração de novos módulos e drivers sem comprometer o sistema já consolidado.

---

## 🌐 Fluxo de Trabalho em Mermaid

O diagrama abaixo resume o fluxo de desenvolvimento e deploy do PandaOS:

```mermaid
graph TD
    A[Planejamento] --> B[Desenvolvimento]
    B --> C{Seleção de Linguagem}
    C -->|Baixo Nível| D[Assembly x86-64]
    C -->|Kernel/Drivers| E[C/C++]
    C -->|Subsistemas| F[Pascal]
    C -->|Automação/Scripts| G[Python]
    
    D --> H[Bootloader/MBR]
    E --> I[Kernel Core]
    F --> J[IPC, Scheduler]
    G --> K[Scripts de Build]
    
    H --> L((Bootloader Compilado))
    I --> M((Kernel Binário))
    J --> N((Bibliotecas))
    K --> O((ISO Gerada))
    
    L --> P[Boot em QEMU]
    M --> P
    N --> P
    O --> P
    
    P --> Q{Testes}
    Q -->|Sucesso ✅| R[Deploy em HW]
    Q -->|Falha ❌| S[Depuração]
    S -->|GDB/Serial Debug| T[Correções]
    T --> B
    
    subgraph CI/CD
        U[Git] --> V[Branch Feature]
        V --> W[Build Noturno 🌙]
        W --> X[Testes Automatizados 🤖]
        X -->|Passou ✅| Y[Merge para Main]
        X -->|Falhou ❌| Z[Alertas por Email]
    end
    
    subgraph Documentação
        A2[Doxygen 📚] --> B2[Doc Técnica]
        C2[Sphinx ✨] --> D2[Manuais]
        E2[JSON Schemas 🛡️] --> F2[Config Validação]
    end
    
    Y --> AA[Release Engineer]
    AA --> AB[ISO Estável]
    AB --> AC[Deploy em Cloud ☁️]
    
    classDef focus fill:#f9f,stroke:#333;
    class P,Q,R,S focus;
```
---

# 🛠️ Current Progress
- ✅ **VBE Support (640x480 8bpp)**
- ✅ **Global Descriptor Table (GDT)**
- ❌ **Entering Protected Mode**
- ✅ **Fonts and Print Functions**
- ✅ **Interrupts (IDT, ISR, IRQ)**
- ✅ **Keyboard Driver**
- ✅ **Mouse Driver**
- ✅ **Memory Management**
- ✅ **File System**
- ✅ **Shell**
- ❌ **Graphical Interface (GUI)**
- ✅ **ELF Loader**
- ❌ **Task State Segment (TSS)**
- ❌ **Network Driver**
- ❌ **Audio Driver**
- ❌ **Processes**
- ❌ **Multitasking**
- ❌ **Installation Setup**
- ❌ **User Documentation**

---

## 💡 Considerações Finais

O PandaOS é um projeto ambicioso que une o melhor das linguagens e paradigmas para criar um sistema operacional robusto, seguro e modular.  
Este repositório serve como referência técnica e guia para desenvolvedores que desejam entender, contribuir e expandir o sistema.

> **Nota:** Este documento será continuamente atualizado à medida que novas funcionalidades forem integradas. Mantenha-se conectado para acompanhar as evoluções do PandaOS! 🔄

---

Sinta-se à vontade para contribuir, reportar issues ou enviar pull requests para ajudar a melhorar este projeto.  
**Happy Coding!** 👨‍💻👩‍💻

---

# created by - Panda12332145 

![Panda12332145' Instagram Profile Picture](https://scontent-gru1-1.cdninstagram.com/v/t51.2885-19/117600834_654064835492344_4051007124330294069_n.jpg?stp=dst-jpg_s150x150_tt6&_nc_ht=scontent-gru1-1.cdninstagram.com&_nc_cat=104&_nc_oc=Q6cZ2AGzi7nuJGYfI5pToRe8PalArBoSQlsQZBQp_Gv89OA_BhXQtSOQsG6FPBTsqwG22Js&_nc_ohc=_mq6YnNl_x0Q7kNvgF8Zvi6&_nc_gid=df0f0866d3e64a5898f5d7b9c21119c2&edm=AP4sbd4BAAAA&ccb=7-5&oh=00_AYCepHqPUAmSlH_gYWOKpDPLYWKuX1mlYgI5-uCyeuxuuA&oe=67B43BEB&_nc_sid=7a9f4b)  

## 🧑‍💻 Sobre Mim  
Sou um apaixonado por **Física Teórica, Cibersegurança e Desenvolvimento de Sistemas**. Busco constantemente **conhecimento profundo** em áreas como hacking, programação de baixo nível e computação avançada. Tenho interesse em **engenharia reversa, criptografia e segurança da informação**, além de um grande apreço por música, filosofia e linguagens.  

## 🌐 Conecte-se Comigo  
- **🔗 Site:** [meusite.com](https://panda-h0me.netlify.app/)  
- **📺 YouTube:** [youtube.com/@X86BinaryGhost](https://www.youtube.com/@X86BinaryGhost)  
- **📸 Instagram:** [@01pandal10](https://www.instagram.com/01pandal10/)  
- **🖥 GitHub:** [github.com/panda12332145](https://github.com/panda12332145)  

## 🚀 Áreas de Interesse  
- **Cibersegurança Avançada** 🔒  
- **Hacking & Engenharia Reversa** 💻  
- **Computação de Baixo Nível** 🖥️  
- **Matemática e Física Teórica** 📐⚛️  
- **Música e Filosofia** 🎵📖  

_"Conhecimento é poder, e a verdadeira liberdade vem do domínio sobre a informação."_  

---

📩 Para colaborações e projetos, sinta-se à vontade para me contatar! [📧Enviar e-mail para Panda12332145](mailto:amandasyscallinjector@gmail.com?subject=Interesse%20no%20projeto%20MAAPC&body=Olá%20Panda12332145,%0D%0A%0D%0AEspero%20que%20este%20e-mail%20lhe%20encontre%20bem.%20tive%20a%20oportunidade%20de%20conhecer%20seu%20projeto%20MAAPC%20no%20GitHub.%0D%0A%0D%0AFiquei%20muito%20interessado%20na%20abordagem%20e%20nas%20funcionalidades%20do%20projeto%20e%20gostaria%20de%20conversar%20mais%20sobre%20ele.%20Se%20possível,%20poderia%20compartilhar%20mais%20detalhes%20ou%20até%20mesmo%20discutirmos%20sobre%20possíveis%20colaborações?%0D%0A%0D%0AAgradeço%20desde%20já%20pela%20atenção%20e%20aguardo%20seu%20retorno.)
