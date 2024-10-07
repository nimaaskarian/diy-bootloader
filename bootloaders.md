---
colortheme: seahorse
theme: Singapore
author: نیما عسکریان
header-includes:
- \usepackage{float}
- \usepackage{qrcode}
- \usepackage{hyperref}
- \usepackage{minted}
- \usepackage{multicol}
- \usepackage{xepersian}
- \settextfont{Bidad}
- \setlatintextfont{Bidad}
- \setminted{fontsize=\scriptsize}
- \setmonofont{JetBrains Mono Regular}
- \title{چجوری یه بوت لودر کوچیک x86 بنویسیم؟}
---

# \today
\titlepage

# بوت
بوت به فرایند روشن شدن کامپیوتر، شناسایی رم، CPU و دستگاه های ورودی و
خروجی و لود شدن سیستم عامل گفته میشه.

این فرایند معمولا سه مرحله کلی داره:

`\begin{latin}`{=latex} 

-   System Firmware
-   OS Loader
-   Operating System

`\end{latin}`{=latex} 


# \LR{System Firmware}
نرم افزاری که معمولا روی ROM نصبه.

یک لایه ست بین سخت افزار و سیستم عامل که اطلاعات مربوط به سخت افزار رو
به سیستم عامل میده.

. . .

وظایف این سیستم به گزینه های زیر تقسیم میشن:

-   POST
-   پیدا کردن و اجرای bootloader
-   خوندن تنظیمات روی CMOS
-   رابط بین سیستم عامل و سخت افزار

نوشتن همچین نرم افزاری پیچیدگی های زیادی داره

# سیستم فیرمور های آزاد
`\begin{latin}`{=latex} 

- SeaBIOS
- Coreboot
- Libreboot

`\end{latin}`{=latex} 

::: center
![Libreboot](libreboot.jpg){ height=50% }
:::

# بوت لودر چیه؟
بوت لودر (یا بوت استرپ لودر) نرم افزاریه که توسط 
\LR{System Firmware}
اجرا میشه و وظیفه اجرای
سیستم عامل رو داره.

CPU میتونه در حالات مختلفی باشه.

+ حالت واقعی (\LR{Real Mode})
+ حالت حفاظت شده (\LR{Protected Mode})
+ حالت طولانی (\LR{Long Mode})

# حالت واقعی (\LR{Real mode})
::: columns
:::: column
`\begin{RTL}`{=latex} 
**دسترسی ها**
`\end{RTL}`{=latex} 

+ دسترسی به تمام \LR{BIOS Interrupt} ها
+ سرعت دسترسی به حافظه بخاطر وجود نداشتن GDT

::::
:::: column
`\begin{RTL}`{=latex} 
**محدودیت ها**
`\end{RTL}`{=latex} 

+ دسترسی به \LR{1MB} از حافظه
+ حفاظت از حافظه به صورت فیزیکی یا حافظه مجازی وجود نداره
+ عملوند های CPU به صورت پیشفرض ۱۶ بیتی هستن
::::
:::

# حالت حفاظت شده (\LR{Protected mode})
::: columns
:::: column
`\begin{RTL}`{=latex} 
**دسترسی ها**
`\end{RTL}`{=latex} 

+ دسترسی به حافظه به صورت حافظه های مجازی با حجم حداکثر \LR{4GB}
+ عملوند های CPU به صورت پیشفرض ۳۲ بیتی هستن
+ حفاظت فیزیکی از حافظه
::::
:::: column
`\begin{RTL}`{=latex} 
**محدودیت ها**
`\end{RTL}`{=latex} 

+ همه \LR{BIOS Interrupt} ها در دسترس نیستن
+ سرعت دسترسی به حافظه کمتره
::::
:::

# نوشتن یک بوت لودر ساده \LR{Real Mode}

\begin{figure}

\begin{latin}
\inputminted{nasm}{bootloader-start.s}
\end{latin}
\caption{فایل bootloader.s}
\end{figure}

# اجرای بوت لودر ساده
میتونیم فایل اسمبل شده 
(`bootloader.bin`)
رو با برنامه 
`wc`
تست کنیم که ببینیم آیا ۵۱۲ بیت هست یا نه.

\begin{latin}
\inputminted{bash}{wc-output.txt}
\end{latin}

::: center
![اجرا با QEMU](2024-10-05-175613-snap.png){width=95%}
:::

# رفتن به \LR{Protected Mode}
مراحل رفتن به حالت ۳۲ بیتی به صورت زیر هست

- غیر فعال کردن Interrupt ها
- فعال کردن خط آدرس A20
- لود کردن یک GDT

<!-- # غیر فعال کردن Interrupt ها -->
<!-- hello -->

# فعال کردن خط آدرس A20

\begin{figure}
\begin{latin}

\inputminted{nasm}{bootloader-a20.s}

\end{latin}

\caption{شروع جدید فایل \latin{bootloader.s}}

\end{figure}

# لود کردن یک GDT

\begin{figure}
\begin{latin}

\inputminted{nasm}{bootloader-gdt.s}

\end{latin}

\caption{ادامه فایل \latin{bootloader.s}}

\end{figure}

# ساختار GDT
![ساختار GDT](gdt.png)

# نوشتن ساختار GDT

\begin{latin}

\inputminted{nasm}{bootloader-gdt-2.s}

\end{latin}

# رفتن به حالت ۳۲ بیتی
\begin{latin}

\inputminted{nasm}{bootloader-32bit.s}

\end{latin}

# نوشتن متن روی بافر متنی VGA
\begin{latin}

\inputminted{nasm}{bootloader-vga.s}

\end{latin}

# خروجیش چیه!؟
![اجرای نسخه آخر بوتلودر با QEMU](/home/nima/Pictures/Screenshots/2024-10-07-212315-snap.png)



# رفرنس ها
`\begin{latin}`{=latex} 

- Quick Boot by Pete Dice
- http://3zanders.co.uk/2017/10/13/writing-a-bootloader/
- https://wiki.osdev.org

`\end{latin}`{=latex} 

سورس کد نهایی:\quad \qrcode{https://raw.githubusercontent.com/nimaaskarian/diy-bootloader/refs/heads/master/bootloader.s}

!ممنون که خوابتون نبرد
