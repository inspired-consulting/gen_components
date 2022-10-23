class SelectableList extends HTMLElement {
    connectedCallback() {
        const $this = this
        this.selectableItems = this.querySelectorAll('[is = "custom-selectable-list-item"]') || []
        this.focusClass = this.getAttribute('focus-class')
        this.focusItem = null

        this.focusItemByValue = (value) => {
            $this.focusItem = focusItemByValue($this, value)
            handleClass($this, $this.focusItem)
        }

        this.addEventListener('custom-selectable-list-item-add', _ => {
            this.selectableItems = this.querySelectorAll('[is = "custom-selectable-list-item"]') || []
        })

        this.addEventListener('custom-selectable-list-item-remove', _ => {
            this.selectableItems = this.querySelectorAll('[is = "custom-selectable-list-item"]') || []
        })

        this.addEventListener('custom-selectable-list-item-click', ({ detail: item }) => {
            select($this, item)
        })

        this.addEventListener('keydown', e => {
            if (e.key == 'Enter') {
                e.stopPropagation()
                e.preventDefault()
                select($this, $this.focusItem)
            } else if (e.key == 'ArrowDown') {
                e.stopPropagation()
                e.preventDefault()
                $this.focusItem = focusNext($this, $this.focusItem)
                handleClass($this, $this.focusItem)
            } else if (e.key == 'ArrowUp') {
                e.stopPropagation()
                e.preventDefault()
                $this.focusItem = focusPrev($this, $this.focusItem)
                handleClass($this, $this.focusItem)
            }
        })
    }
}

const select = (el, focusItem) => {
    if (focusItem && focusItem.style.display !== 'none') {
        const value = focusItem.itemValue
        el.dispatchEvent(new CustomEvent('custom-selectable-list-select', { detail: { value: value, item: focusItem }, cancelable: true, bubbles: true }))
    }
}

const handleClass = (el, focusItem) => {
    if (!el.focusClass) return
    [...el.selectableItems].forEach(element => element.classList.toggle(el.focusClass, false))
    focusItem && focusItem.classList.toggle(el.focusClass, true)
}

const focusItemByValue = (el, value) => {
    return validItems(el).find(e => e.itemValue === value)
}

const focusNext = (el, focusItem) => {
    const selectableItems = validItems(el)
    const fallback = selectableItems[0] || null
    if (null !== focusItem) {
        return selectableItems[selectableItems.indexOf(focusItem) + 1] || fallback
    }
    return fallback
}

const focusPrev = (el, focusItem) => {
    const selectableItems = validItems(el)
    const fallback = selectableItems[selectableItems.length - 1] || null
    if (null !== focusItem) {
        return selectableItems[selectableItems.indexOf(focusItem) - 1] || fallback
    }
    return fallback
}

const validItems = (el) => [...el.selectableItems].filter(e => e.style.display !== 'none').filter(e => e.isConnected)

class SearchableListItem extends HTMLLIElement {
    connectedCallback() {
        this.itemValue = this.getAttribute('item-value')
        this.dispatchEvent(new CustomEvent('custom-selectable-list-item-add', { detail: this, cancelable: true, bubbles: true }))
        this.addEventListener('click', e => {
            e.stopPropagation()
            e.preventDefault()
            this.dispatchEvent(new CustomEvent('custom-selectable-list-item-click', { detail: this, cancelable: true, bubbles: true }))
        })

    }
    disconnectedCallback() {
        this.dispatchEvent(new CustomEvent('custom-selectable-list-item-remove', { detail: this, cancelable: true, bubbles: true }))
    }
}

window.customElements.define('custom-selectable-list', SelectableList)
window.customElements.define('custom-selectable-list-item', SearchableListItem, { extends: 'li' })
