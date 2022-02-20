module.exports = {
	content: [
		"./index.html",
		"./src/**/*.{vue,js,jsx}",
	],
	theme: {
		extend: {
		    colors: {
                "atl-1": "#215F96",
		    },
		    borderWidth: {
                "1": "1px",
            },
            height: {
                "95%": "99%",
            },
            width: {
                "90%": "90%",
            }
		},
	},
	plugins: [
	    require('tailwind-scrollbar'),
	],
}