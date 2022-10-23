class SearchableSelect extends HTMLElement {
    connectedCallback() {
        const $this = this
        this.dropdown = this.querySelector('custom-dropdown')
        this.searchableList = this.querySelector('custom-searchable-list')
        this.selectableList = this.querySelector('custom-selectable-list')
        this.trigger = this.querySelector('button')

        this.addEventListener('custom-selectable-list-select', ({ detail: { value } }) => {
            const input = $this.querySelector('[data-searchable-select-input]')
            input.querySelectorAll('[selected]').forEach(element => element.selected = false)
            const newSelected = input.querySelector(`[value = "${value}"]`)
            if (newSelected) newSelected.selected = true
            $this.dropdown.close()
            input.dispatchEvent(new Event('change', { cancelable: true, bubbles: true }))
        })

        this.addEventListener('custom-dropdown-open', _ => {
            const selected = $this.querySelector('[data-searchable-select-input] [selected]')
            $this.selectableList.focusItemByValue(selected && selected.value || null)
            $this.searchableList.focusSearch()
        })

        this.addEventListener('custom-dropdown-close', _ => {
            $this.trigger.focus()
        })

        this.addEventListener('keydown', e => {
            if (['Enter'].includes(e.key)) {
                e.preventDefault()
            }
        })

    }
}

window.customElements.define('custom-searchable-select', SearchableSelect)
