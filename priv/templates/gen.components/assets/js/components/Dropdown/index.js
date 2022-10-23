class Dropdown extends HTMLElement {
    connectedCallback() {
        const $this = this
        this.dropdown = this.querySelector('[data-dropdown-expandable]')
        this.trigger = this.querySelector('[data-dropdown-trigger]')

        this.open = () => open($this)
        this.close = () => close($this)

        this.trigger.addEventListener('click', e => {
            e.preventDefault()
            e.stopImmediatePropagation()
            if (isOpen($this)) {
                close($this)
            } else {
                open($this)
            }
        })

        this.dropdown.addEventListener('click', e => {
            e.preventDefault()
            e.stopImmediatePropagation()
            return false;
        })

        window.addEventListener('click', _ => {
            isOpen($this) && close($this)
        })

        window.addEventListener('keydown', e => {
            if (isOpen($this) && ['Esc', 'Escape'].includes(e.key)) {
                e.preventDefault()
                close($this)
            }
        })
    }
}

const isOpen = function (el) {
    return el.trigger.getAttribute('aria-expanded') == 'true'
}

const open = function (el) {
    el.trigger.setAttribute('aria-expanded', 'true')
    el.dropdown.style.display = 'block';
    el.dispatchEvent(new Event('custom-dropdown-open', { cancelable: true, bubbles: true }))
}

const close = function (el) {
    el.dropdown.style.display = 'none';
    el.trigger.setAttribute('aria-expanded', 'false')
    el.dispatchEvent(new Event('custom-dropdown-close', { cancelable: true, bubbles: true }))
}

window.customElements.define('custom-dropdown', Dropdown)
