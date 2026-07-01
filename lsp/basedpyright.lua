return {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "recommended",
				diagnosticMode = "off",
				useLibraryCodeForTypes = true,
				inlayHints = {
					callArgumentNames = true,
					variableTypes = true,
				},
			},
		},
	},
}
