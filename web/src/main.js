import { createApp, h } from 'vue'
import App from './App.vue'
import { NConfigProvider, darkTheme } from 'naive-ui'
import './index.css'

const themeOverrides = {
	common: {
		"fontFamily": 'Inter',
		"fontWeight": "500",
		"fontWeightStrong": "700",
		"backgroundColor": "transparent",
		"boxShadowFocus": `0 0 8px 0 rgba(85, 162, 230, 0.3)`
	},
	Select: {
		peers: {
			InternalSelection: {
				borderHover: `1px solid #178AD1`,
				borderActive: `1px solid #178AD1`,
				borderFocus: `1px solid #178AD1`,
				"boxShadowFocus": `0 0 8px 0 rgba(85, 162, 230, 0.3)`
			}
		}
	},
	Input: {
		"caretColor": "#55A2E6FF",
		"borderHover": `1px solid #178AD1`,
		"borderFocus": `1px solid #178AD1`,
		"boxShadowFocus": `0 0 8px 0 rgba(85, 162, 230, 0.3)`
	},
	Message: {
		"colorError": "rgba(125, 76, 76, 1)",
		"colorSuccess": "rgba(84, 153, 105, 1)",
		"textColor": "rgba(255, 255, 255, 1)",
		"textColorInfo": "rgba(255, 255, 255, 1)",
		"textColorSuccess": "rgba(255, 255, 255, 1)",
		"textColorWarning": "rgba(255, 255, 255, 1)",
		"textColorLoading": "rgba(255, 255, 255, 1)",
		"textColorError": "rgba(255, 255, 255, 1)",
		"colorInfo": "rgba(60, 82, 112, 1)",
		"colorWarning": "rgba(156, 139, 71, 1)",
		"colorLoading": "rgba(123, 123, 123, 1)"
	},
	Dialog: {
		"color": "rgba(75, 85, 99, 1)",
		"titleTextColor": "rgba(255, 255, 255, 1)",
		"textColor": "rgba(255, 255, 255, 0.78)"
	}
}

const app = createApp({
	render: () => h(NConfigProvider, {theme: darkTheme, themeOverrides: themeOverrides}, {
		default: () => h(App)
	})
})

const meta = document.createElement('meta')
meta.name = 'naive-ui-style'
document.head.appendChild(meta)

app.mount('#app')