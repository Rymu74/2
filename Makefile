kernel_source := $(shell find src/kernel -name *.c)
kernel_objects := $(patsubst src/kernel/%.c, build/kernel/%.o, $(kernel_source))

c_source := $(shell find lib/ -name *.c)
c_objects := $(patsubst lib/%.c, build/%.o, $(c_source))

asm_source := $(shell find src/boot -name *.asm)
asm_objects := $(patsubst src/boot/%.asm, build/%.o, $(asm_source))

x86_objects := $(c_objects) $(asm_objects)

$(kernel_objects): build/kernel/%.o: src/kernel/%.c
	mkdir -p $(dir $@)
	gcc -c -I include/ -ffreestanding $(patsubst build/kernel/%.o, src/kernel/%.c, $@) -o $@

$(c_objects): build/%.o: lib/%.c
	mkdir -p $(dir $@)
	gcc -c -I include/ -ffreestanding $(patsubst build/%.o, lib/%.c, $@) -o $@

$(asm_objects): build/%.o: src/boot/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 $(patsubst build/%.o, src/boot/%.asm, $@) -o $@

.PHONY: iso
iso: $(kernel_objects) $(x86_objects)
	mkdir -p dist
	ld -n -o dist/rymuos -T src/linker.ld $(kernel_objects) $(x86_objects)
	cp dist/rymuos iso_root/rymuos
	git clone https://github.com/limine-bootloader/limine.git --branch=v5.x-branch-binary --depth=1
	make -C limine
	cp -v dist/rymuos limine/limine-bios.sys limine/limine-bios-cd.bin limine/limine-uefi-cd.bin iso_root/
	mkdir -p iso_root/EFI/BOOT
	cp -v limine/BOOTIA32.EFI limine/BOOTX64.EFI iso_root/EFI/BOOT/
	xorriso -as mkisofs -b limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot limine-uefi-cd.bin -efi-boot-part --efi-boot-image --protective-msdos-label iso_root -o rymuos.iso
	./limine/limine bios-install rymuos.iso
	rm -rf limine/

.PHONY: clean
clean:
	rm -rf dist/ build/ limine/ rymuos.iso 
	rm -rf iso_root/rymuos iso_root/EFI/ iso_root/limine-bios-cd.bin iso_root/limine-bios.sys iso_root/limine-uefi-cd.bin 
