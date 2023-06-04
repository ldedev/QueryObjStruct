
# QueryObjStruct

[README.md](README.md) in English

QueryObjStruct Nos possibilita realizar consultas em um json(apenas por enquanto), yaml e toml, de forma dinâmica...

E as expectativas é de que não seja necessário mudar em nada na consultas, apenas informar qual a estrutura do objeto.


## Funcionalidades

- [X] Estrutura JSON
- [ ] Estrutura YAML
- [ ] Estrutura TOML
- [X] Multiplataforma
- [X] Consultas em chaves simples
- [X] Consultas em chaves compostas
- [X] Uso de funções em consultas(Apenas 4 por enquanto)
- [X] Consultas em arrays
- [X] Consultas em arrays de objetos
- [X] Preview em tempo real
- [ ] Temas dark e light(Apenas automático por enquanto)



# Documentação

### Funções

 - **[(len [arg1])](#function-len)**
 - **[(sum \*arg1)](#function-sum)**
 - **[(sequal \*arg1, \*arg2)](#function-sequal)**
 - **[(eequal \*arg1, \*arg2)](#function-eequal)**


_(Json obtido de um dos endpoints do BrasilApi)_
```json
[
  {
    "nome": "Selic",
    "valor": 13.75
  },
  {
    "nome": "CDI",
    "valor": 13.65
  },
  {
    "nome": "IPCA",
    "valor": 4.18
  }
]
```

#### Para pegarmos apenas os nomes desse array de objeto basta digita a seguinte consulta...

`*.nome` ▶️ RUN!
```json
[
  "Selic",
  "CDI",
  "IPCA"
]
```

#### Para pegar apenas o primeiro objeto do array...

`[0]` ▶️ RUN!
```json
{
  "nome": "Selic",
  "valor": 13.75
}
```

#### Para pegar apenas o campo 'valor' do segundo objeto do array...

`[1].valor`

```json
13.75
```


Certo agora vamos complicar um pouco mais as coisas, vamos usar funções.


## function len

Primeiro argumento é opcional, porém é preciso que seja uma chave.
É possível contar número de array e de caracteres de um conteúdo.

ex:

`([0].(len @nome))` ▶️ RUN!
```
5
```
ou

`[0].nome.(len)` ▶️ RUN!
```
5
```

`(len)` ▶️ RUN!
```
3
```
Acima está contando o número de array.

## function sum

Primeiro argumento é obrigatório

`[0].nome.(len)` ▶️ RUN!
```
5
```

## function sequal

Retorna todos os objetos do array que a chave (@key) comece com o conteúdo.

`(sequal @valor, 4)` ▶️ RUN!

ou

`(sequal 4, @valor)` ▶️ RUN!
```
[
  {
    "nome": "IPCA",
    "valor": 4.18
  }
]
```

## function eequal

Retorna todos os objetos do array que a chave (@key) termine com o conteúdo.

`(eequal @valor, 5)` ▶️ RUN!
```
[
  {
    "nome": "Selic",
    "valor": 13.75
  },
  {
    "nome": "CDI",
    "valor": 13.65
  }
]
```
<br/>

# Stack utilizada

**Back-end:** [Vlang](https://vlang.io/)

**Front-end:** [pico.css](https://picocss.com/)

**Icon:** [lucide](https://lucide.dev/license)

**Code editor:** [ace](https://ace.c9.io/)

**fonts:** [google fonts](https://fonts.googleapis.com)
