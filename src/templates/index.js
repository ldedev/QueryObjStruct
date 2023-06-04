        var editorResultJson = ace.edit("editorResultJson");
        var editorJson = ace.edit("editorJson");

        editorResultJson.setTheme("ace/theme/dracula");
        editorResultJson.setOptions({
            fontFamily: "JetBrains Mono",
            fontSize: "14pt"
        });
        editorResultJson.session.setMode("ace/mode/json");


        editorJson.setTheme("ace/theme/dracula");
        editorJson.setOptions({
            fontFamily: "JetBrains Mono",
            fontSize: "14pt"
        });
        editorJson.session.setMode("ace/mode/json");

        //temp
        editorJson.setValue('[{"nome":"Selic","valor":13.75},{"nome":"CDI","valor":13.65},{"nome":"IPCA","valor":4.18}]');

        document.getElementsByName('query')[0].addEventListener('keydown', (e) =>
        {
            if (e.keyCode == 13)
                RunQuery();
        });

        function validAndReturnCode() {
            try {
                const code = editorJson.getValue();
                const valid = JSON.parse(code);

                return code;
            } catch (e) {}

            return '';
        }

        function RunQuery() {
            let query = document.getElementsByName('query')[0].value;

            axios(
                {
                    method: 'POST',
                    url: `/submit`,
                    data: {
                        query: query,
                        code: validAndReturnCode()
                    }
                }
            ).then(resp => {
                editorResultJson.setValue(JSON.stringify(resp.data, null, 2));
            });
        }
