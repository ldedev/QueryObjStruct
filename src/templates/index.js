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
        editorJson.setValue('{"Teste":[{"discount":0.3},{"discount":2.33}]}');

        function validAndReturnCode() {
            try {
                const code = editorJson.getValue();
                const valid = JSON.parse(code);

                return code;
            } catch (e) {}

            return '';
        }

        function RunQuery() {
            let query = document.getElementsByName('name')[0].value;

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
