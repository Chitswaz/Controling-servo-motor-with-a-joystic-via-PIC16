# Microcontroller PWM and ADC Configuration

This project demonstrates how to configure and use the ADC (Analog-to-Digital Converter) and PWM (Pulse Width Modulation) features on the PIC16F18446 microcontroller. The code is written in assembly language and is designed to set up the microcontroller for a PWM-based application using an analog input.

## Features
- **PWM Output**: Configured on RA1 using PWM6.
- **ADC Input**: Configured on RA4 to read analog signals.
- **Clock Configuration**: Uses internal FOSC for clock settings.
- **Timer Configuration**: Timer2 is configured for PWM signal timing.
- **Dynamic PWM Duty Cycle**: The ADC input is dynamically transformed to adjust the PWM output.

## Prerequisites
- MPLAB X IDE.
- XC8 Compiler.
- PIC16F18446 Microcontroller.
- Analog signal source for ADC input (e.g., potentiometer).
- Oscilloscope or logic analyzer to observe the PWM output.

## Setup
1. **Hardware**:
   - Connect an analog signal source to RA4 (pin corresponding to ANA4).
   - Connect an LED or another PWM-driven load to RA1 (PWM6 output).
2. **Software**:
   - Load the provided assembly code into MPLAB X IDE.
   - Compile the code and program it into the PIC16F18446 microcontroller.

## How It Works
### 1. System Initialization
- **Clock Configuration**:
  - The internal oscillator is configured with a frequency of 4 MHz.
- **PWM Configuration**:
  - Timer2 is initialized with a period of 156 (PR2 = 156).
  - PWM duty cycle is set dynamically based on the ADC value.
- **ADC Configuration**:
  - The ADC is set to use RA4 (ANA4) as the input channel.
  - Voltage reference is configured to use Vdd and Vss.

### 2. PWM Duty Cycle Update
- The ADC reads the analog input from RA4.
- The ADC value is scaled and transformed to calculate the PWM duty cycle.
- The calculated duty cycle is loaded into PWM6DCH and PWM6DCL registers.

### 3. Main Loop
- The program continuously reads the ADC value, transforms it, and updates the PWM duty cycle.
- A timer is used to handle PWM timing, ensuring stable output.

## Key Registers Used
- **OSCCON1**: Configures the oscillator mode.
- **TRISA/TRISC**: Configures pin directions.
- **ANSELA**: Enables analog functions on specific pins.
- **PWM6CON**: Controls the PWM module.
- **T2CON**: Configures Timer2 for PWM timing.
- **ADCON0/ADREF/ADPCH**: Configures the ADC module.

## Usage
- Vary the analog input (e.g., turn a potentiometer connected to RA4) and observe the PWM signal changes on RA1 using an oscilloscope or an LED.
- Adjustments in the ADC input dynamically affect the brightness of the LED or the duty cycle of the PWM output.

## Notes
- The code demonstrates essential microcontroller features but can be extended for additional functionality.
- Ensure proper connections and power supply to avoid damage to the microcontroller or connected components.

## Future Improvements
- Implement ADC interrupt-based updates for improved efficiency.
- Add error handling for out-of-range ADC inputs.
- Use an external oscillator for more precise timing if needed.

## License
This project is open-source and can be freely modified or redistributed.

---

Happy coding with PIC microcontrollers!
