/**
 * Validaciones de Formularios
 * Archivo: validaciones.js
 * Proporciona validaciones en tiempo real para los campos del formulario de login y registro
 */

document.addEventListener('DOMContentLoaded', function() {
    
    // ==========================================
    // VALIDACIÓN: Solo números en documento
    // ==========================================
    const documentoInput = document.getElementById('documento_usuario');
    if (documentoInput) {
        documentoInput.addEventListener('input', function(e) {
            // Permitir solo números
            this.value = this.value.replace(/[^0-9]/g, '');
            
            // Feedback visual
            validarDocumento(this);
        });

        // Validación al perder foco
        documentoInput.addEventListener('blur', function() {
            validarDocumento(this);
        });
    }

    // ==========================================
    // VALIDACIÓN: Nombre de Usuario (alfanumérico + guiones bajos)
    // ==========================================
    const nombreUsuarioRegInput = document.getElementById('nombre_usuario_reg');
    if (nombreUsuarioRegInput) {
        nombreUsuarioRegInput.addEventListener('input', function(e) {
            // Permitir solo letras (sin números ni guiones bajos)
            this.value = this.value.replace(/[^a-zA-Z]/g, '');
            
            // Convertir a minúsculas automáticamente
            this.value = this.value.toLowerCase();
            
            validarNombreUsuario(this);
        });

        nombreUsuarioRegInput.addEventListener('blur', function() {
            validarNombreUsuario(this);
        });
    }

    // ==========================================
    // VALIDACIÓN: Contraseña (requisitos mínimos)
    // ==========================================
    const passwordRegInput = document.getElementById('password_reg');
    if (passwordRegInput) {
        passwordRegInput.addEventListener('input', function(e) {
            validarPassword(this);
        });

        passwordRegInput.addEventListener('blur', function() {
            validarPassword(this);
        });
    }

    // ==========================================
    // VALIDACIÓN: Nombre de Usuario Login
    // ==========================================
    const loginNombreUsuarioInput = document.getElementById('login_nombre_usuario');
    if (loginNombreUsuarioInput) {
        loginNombreUsuarioInput.addEventListener('input', function(e) {
            // Permitir solo letras
            this.value = this.value.replace(/[^a-zA-Z]/g, '');
            this.value = this.value.toLowerCase();
        });
    }

    // ==========================================
    // VALIDACIÓN: Formulario Registro Completo
    // ==========================================
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            if (!validarFormularioRegistro()) {
                e.preventDefault();
                return false;
            }
        });
    }

});

/**
 * Valida el campo de documento
 * @param {HTMLElement} element - Input element del documento
 */
function validarDocumento(element) {
    const documento = element.value.trim();
    const errorMsg = element.parentElement.querySelector('.error-msg');
    
    // Eliminar mensaje de error anterior si existe
    if (errorMsg) {
        errorMsg.remove();
    }

    // Validar longitud
    if (documento.length > 0 && documento.length < 5) {
        mostrarError(element, 'El documento debe tener al menos 5 dígitos');
        element.classList.add('is-invalid');
        element.classList.remove('is-valid');
        return false;
    } else if (documento.length >= 5 && documento.length <= 20) {
        element.classList.add('is-valid');
        element.classList.remove('is-invalid');
        return true;
    } else if (documento.length > 20) {
        mostrarError(element, 'El documento no puede exceder 20 dígitos');
        element.classList.add('is-invalid');
        element.classList.remove('is-valid');
        return false;
    }

    element.classList.remove('is-valid', 'is-invalid');
    return true;
}

/**
 * Valida el nombre de usuario
 * @param {HTMLElement} element - Input element del nombre de usuario
 */
function validarNombreUsuario(element) {
    const nombreUsuario = element.value.trim();
    const errorMsg = element.parentElement.querySelector('.error-msg');
    
    // Eliminar mensaje de error anterior si existe
    if (errorMsg) {
        errorMsg.remove();
    }

    // Validar longitud
    if (nombreUsuario.length > 0 && nombreUsuario.length < 3) {
        mostrarError(element, 'El nombre de usuario debe tener al menos 3 caracteres');
        element.classList.add('is-invalid');
        element.classList.remove('is-valid');
        return false;
    } else if (nombreUsuario.length >= 3 && nombreUsuario.length <= 20) {
        element.classList.add('is-valid');
        element.classList.remove('is-invalid');
        return true;
    } else if (nombreUsuario.length > 20) {
        mostrarError(element, 'El nombre de usuario no puede exceder 20 caracteres');
        element.classList.add('is-invalid');
        element.classList.remove('is-valid');
        return false;
    }

    element.classList.remove('is-valid', 'is-invalid');
    return true;
}

/**
 * Valida la contraseña
 * @param {HTMLElement} element - Input element de la contraseña
 */
function validarPassword(element) {
    const password = element.value;
    const errorMsg = element.parentElement.querySelector('.error-msg');
    
    // Eliminar mensaje de error anterior si existe
    if (errorMsg) {
        errorMsg.remove();
    }

    let errores = [];

    // Validar longitud mínima
    if (password.length > 0 && password.length < 6) {
        errores.push('Mínimo 6 caracteres');
    }

    // Validar longitud máxima
    if (password.length > 50) {
        errores.push('Máximo 50 caracteres');
    }

    // Mostrar errores si existen
    if (errores.length > 0) {
        mostrarError(element, errores.join(', '));
        element.classList.add('is-invalid');
        element.classList.remove('is-valid');
        return false;
    } else if (password.length >= 6) {
        element.classList.add('is-valid');
        element.classList.remove('is-invalid');
        return true;
    }

    element.classList.remove('is-valid', 'is-invalid');
    return true;
}

/**
 * Valida el formulario de registro completo
 * @returns {boolean} - True si es válido, false si no
 */
function validarFormularioRegistro() {
    const documento = document.getElementById('documento_usuario');
    const nombreUsuario = document.getElementById('nombre_usuario_reg');
    const password = document.getElementById('password_reg');

    let esValido = true;

    // Validar documento
    if (!validarDocumento(documento)) {
        esValido = false;
    }

    // Validar nombre de usuario
    if (!validarNombreUsuario(nombreUsuario)) {
        esValido = false;
    }

    // Validar contraseña
    if (!validarPassword(password)) {
        esValido = false;
    }

    if (!esValido) {
        alert('Por favor, completa correctamente todos los campos requeridos.');
    }

    return esValido;
}

/**
 * Muestra un mensaje de error debajo del input
 * @param {HTMLElement} element - Input element
 * @param {string} mensaje - Mensaje de error a mostrar
 */
function mostrarError(element, mensaje) {
    // Crear elemento de error
    const errorDiv = document.createElement('small');
    errorDiv.className = 'error-msg text-danger d-block mt-1';
    errorDiv.textContent = '⚠ ' + mensaje;
    
    // Insertar después del input
    element.parentElement.insertBefore(errorDiv, element.nextSibling);
}

/**
 * Formatea el documento mientras se escribe (opcional: añade separadores)
 * Por ejemplo: 1234567890 -> 1.234.567-890
 */
function formatearDocumento(value) {
    // Remover caracteres no numéricos
    const cleanValue = value.replace(/[^0-9]/g, '');
    
    // Aplicar formato (ajusta según el formato de tu país)
    // Este es un ejemplo genérico: XXX-XXX-XXX-X
    if (cleanValue.length > 0) {
        return cleanValue
            .replace(/(\d{1,3})(?=\d{3})/g, '$1.')
            .replace(/\.(\d{3})$/, '-$1');
    }
    
    return cleanValue;
}

/**
 * Toggle para mostrar/ocultar contraseña
 * Se ejecuta cuando el documento está listo
 */
function inicializarTogglePassword() {
    // Campos de contraseña
    const passwordFields = [
        { input: document.getElementById('password_reg'), toggleId: 'toggle-password-reg' },
        { input: document.getElementById('login_password'), toggleId: 'toggle-password-login' }
    ];

    passwordFields.forEach(field => {
        if (field.input) {
            // Crear el botón toggle si no existe
            crearBotonTogglePassword(field.input, field.toggleId);
        }
    });
}

/**
 * Crea el botón de toggle para mostrar/ocultar contraseña
 * @param {HTMLElement} passwordInput - Input de contraseña
 * @param {string} toggleId - ID único para el botón
 */
function crearBotonTogglePassword(passwordInput, toggleId) {
    // Crear contenedor para el input y el botón
    const wrapper = document.createElement('div');
    wrapper.className = 'password-wrapper';
    wrapper.style.position = 'relative';
    wrapper.style.display = 'flex';
    wrapper.style.alignItems = 'center';
    wrapper.style.width = '100%';

    // Insertar el wrapper antes del input
    passwordInput.parentNode.insertBefore(wrapper, passwordInput);

    // Mover el input dentro del wrapper
    wrapper.appendChild(passwordInput);

    // Crear el botón toggle con SVG
    const toggleBtn = document.createElement('button');
    toggleBtn.type = 'button';
    toggleBtn.id = toggleId;
    toggleBtn.className = 'toggle-password-btn';
    toggleBtn.title = 'Mostrar contraseña';
    
    // SVG del ojo abierto
    toggleBtn.innerHTML = `
        <svg class="eye-icon eye-open" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
            <circle cx="12" cy="12" r="3"></circle>
        </svg>
        <svg class="eye-icon eye-closed" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
            <line x1="1" y1="1" x2="23" y2="23"></line>
        </svg>
    `;
    
    // Estilos del botón
    Object.assign(toggleBtn.style, {
        position: 'absolute',
        right: '12px',
        border: 'none',
        background: 'transparent',
        cursor: 'pointer',
        padding: '5px 10px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: '10',
        color: '#999',
        transition: 'color 0.3s ease'
    });

    // Agregar evento al botón
    toggleBtn.addEventListener('click', function(e) {
        e.preventDefault();
        
        const eyeOpen = toggleBtn.querySelector('.eye-open');
        const eyeClosed = toggleBtn.querySelector('.eye-closed');
        
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeOpen.style.display = 'none';
            eyeClosed.style.display = 'block';
            toggleBtn.title = 'Ocultar contraseña';
            toggleBtn.style.color = '#666';
        } else {
            passwordInput.type = 'password';
            eyeOpen.style.display = 'block';
            eyeClosed.style.display = 'none';
            toggleBtn.title = 'Mostrar contraseña';
            toggleBtn.style.color = '#999';
        }
    });

    // Agregar eventos hover
    toggleBtn.addEventListener('mouseenter', function() {
        if (passwordInput.type === 'password') {
            toggleBtn.style.color = '#666';
        } else {
            toggleBtn.style.color = '#444';
        }
    });

    toggleBtn.addEventListener('mouseleave', function() {
        if (passwordInput.type === 'password') {
            toggleBtn.style.color = '#999';
        } else {
            toggleBtn.style.color = '#666';
        }
    });

    // Agregar el botón al wrapper
    wrapper.appendChild(toggleBtn);

    // Ajustar el padding del input para dejar espacio al botón
    passwordInput.style.paddingRight = '45px';
}

// Ejecutar cuando el documento esté listo
document.addEventListener('DOMContentLoaded', function() {
    inicializarTogglePassword();
});
