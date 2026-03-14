# ⚡ Energy Link (V6.0)
### Gestão de Créditos de Energia Solar via Smart Contract

Este projeto foi desenvolvido para automatizar a gestão, auditoria e transferência de créditos de energia solar distribuída. O sistema utiliza a tecnologia Blockchain para garantir que cada kWh gerado seja registrado de forma imutável e vinculada a uma Unidade Consumidora (UC) real.

## 🚀 O que este projeto resolve?
No modelo atual de geração distribuída, o rateio de créditos costuma ser manual e burocrático. O **WEG Energy Link** resolve isso através de:

- **Transparência Total:** Auditoria em tempo real de geração e consumo sem necessidade de planilhas.
- **Monetização Automatizada:** O sistema retém uma taxa de 1% em cada transação para sustentar a operação da rede.
- **Compliance ANEEL:** Cada carteira digital é vinculada a uma Unidade Consumidora (UC), atendendo às normas de identificação de beneficiários.
- **Previsibilidade Financeira:** Conversão instantânea de kWh para Reais baseada na bandeira tarifária atual.

## 🛠️ Pilares Técnicos
- **Padrão ERC-20:** Facilidade de integração com outras carteiras e sistemas digitais.
- **Oracle de Preço:** Função dedicada para o Administrador atualizar o valor do kWh.
- **Logs de Auditoria:** Eventos de "Fatura Gerada" registrados diretamente na rede para exportação.

## 📝 Como testar (Remix IDE)
1. Importe o arquivo `creditoEnergia.sol` no [Remix IDE](https://remix.ethereum.org).
2. Compile utilizando a versão de Solidity `0.8.20`.
3. No Deploy, utilize o endereço do Administrador para gerenciar as taxas e cadastrar as UCs.
4. Utilize a função `cadastrarUnidadeConsumidora` antes de realizar transferências para garantir o compliance.


graph TD
    %% Entidades
    SolarPanel[Usina Solar/IoT] -- "Geração Real (kWh)" --> Medidor[Medidor Inteligente WEG]
    Medidor -- "Chamada registrarGeracao()" --> SC[Smart Contract: kWHW]
    
    %% Lógica do Contrato
    subgraph SC_Logic [Smart Contract Blockchain]
        SC -- "Mint (1:1)" --> UserWallet[Carteira do Prosumidor]
        SC -- "Verifica UC Ativa" --> DB[Mapeamento de UC/Compliance]
    end

    %% Transação P2P
    UserWallet -- "Transferência P2P" --> Vizinho[Carteira do Vizinho]
    
    %% Monetização
    subgraph Receita
        Vizinho -- "99% do Crédito" --> VizinhoSaldo[Saldo de Energia]
        Vizinho -- "1% de Taxa" --> AdminWallet[Carteira Negócios/Admin]
    end

    %% Valor Real
    AdminWallet -- "Acúmulo de Taxas" --> Profit[Sustentabilidade da Plataforma]
    VizinhoSaldo -- "Fatura Digital" --> Celesc[Compensação na Distribuidora]

    %% Estilos
    style SC fill:#f9f,stroke:#333,stroke-width:4px
    style AdminWallet fill:#dfd,stroke:#080,stroke-width:2px
    style SolarPanel fill:#fff4dd,stroke:#d4a017


---
**Desenvolvido por:** [filhormnilton](https://github.com/filhormnilton)  
**Localização:** Jaraguá do Sul, SC - Brasil
