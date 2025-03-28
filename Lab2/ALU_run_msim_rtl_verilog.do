# Crear librería de trabajo si no existe
if {![file exists rtl_work]} {
    vlib rtl_work
}
vmap work rtl_work

# Compilar los archivos
vlog -sv OpCodeEnum.sv
vlog -sv ALU.sv
vlog -sv ALU_testbench.sv

# Simulación
vsim work.ALU_testbench

# Añadir todas las señales al waveform
add wave -recursive *

# Ejecutar 100ns
run 100ns

