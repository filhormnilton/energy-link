// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenEnergiaWEG is ERC20 {
    address public admin;
    uint256 public precoKwhEmCentavos; 
    
    // Pilar Jurídico: Vínculo com a Unidade Consumidora (UC)
    struct DadosCliente {
        string numeroUC;      // Cadastro na Celesc
        string idContrato;    // Vínculo com Cooperativa/Condomínio
        bool ativo;
    }

    mapping(address => DadosCliente) public cadastroClientes;
    mapping(address => bool) public eMedidorAutorizado;

    // Eventos para Auditoria, BI e Compliance
    event ClienteCadastrado(address indexed carteira, string uc);
    event FaturaGerada(address indexed cliente, string uc, uint256 saldoAtual, uint256 timestamp);
    event PrecoAtualizado(uint256 novoPreco);

    constructor() ERC20("Credito Energia WEG", "kWHW") {
        admin = msg.sender;
        eMedidorAutorizado[msg.sender] = true;
        precoKwhEmCentavos = 85; // R$ 0,85 base
    }

    // --- CAMADA DE GOVERNANÇA E JURÍDICO ---

    function cadastrarUnidadeConsumidora(address _carteira, string memory _uc, string memory _contrato) public {
        require(msg.sender == admin, "Apenas o admin cadastra unidades");
        cadastroClientes[_carteira] = DadosCliente(_uc, _contrato, true);
        emit ClienteCadastrado(_carteira, _uc);
    }

    function autorizarMedidor(address _novoMedidor) public {
        require(msg.sender == admin, "Apenas o admin autoriza medidores");
        eMedidorAutorizado[_novoMedidor] = true;
    }

    // --- CAMADA FINANCEIRA E BI ---

    function definirPrecoKwh(uint256 _novoPrecoCentavos) public {
        require(msg.sender == admin, "Apenas o admin ajusta o preco");
        precoKwhEmCentavos = _novoPrecoCentavos;
        emit PrecoAtualizado(_novoPrecoCentavos);
    }

    function consultarValorEmReais(address _usuario) public view returns (uint256) {
        uint256 saldo = balanceOf(_usuario);
        return (saldo * precoKwhEmCentavos) / 100; 
    }

    // --- OPERAÇÃO DE ENERGIA ---

    function registrarGeracao(address _gerador, uint256 _quantidade) public {
        require(eMedidorAutorizado[msg.sender], "Medidor nao autorizado");
        require(cadastroClientes[_gerador].ativo, "Gerador sem UC ativa");
        _mint(_gerador, _quantidade); 
    }

    function verMeuSaldo() public returns (uint256) {
        uint256 saldo = balanceOf(msg.sender);
        string memory uc = cadastroClientes[msg.sender].numeroUC;
        emit FaturaGerada(msg.sender, uc, saldo, block.timestamp);
        return saldo;
    }

    // Monetização e Transferência P2P com Compliance
    function transfer(address _destinatario, uint256 _quantidade) public override returns (bool) {
        // Trava Jurídica: Impede envio para quem não é da cooperativa (sem UC)
        require(cadastroClientes[_destinatario].ativo, "Destinatario nao cadastrado no sistema");
        
        uint256 taxa = _quantidade / 100;
        uint256 valorLiquido = _quantidade - taxa;

        _transfer(msg.sender, admin, taxa); // Sua receita
        _transfer(msg.sender, _destinatario, valorLiquido); // Transferência do crédito
        
        return true;
    }
}