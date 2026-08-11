#include "pico/stdlib.h"

int main() {
    // Inicializar stdio para ver mensajes si se usa depuración (opcional)
    stdio_init_all();

    // El LED de la Pico está conectado al pin 25
    const uint LED_PIN = 25;
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);

    while (true) {
        gpio_put(LED_PIN, 1);
        sleep_ms(1000);
        gpio_put(LED_PIN, 0);
        sleep_ms(1000);
    }
}