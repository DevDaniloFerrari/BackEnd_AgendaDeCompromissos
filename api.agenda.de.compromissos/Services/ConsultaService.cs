﻿using api.agenda.de.compromissos.Exceptions;
using api.agenda.de.compromissos.Interfaces.Repositories;
using api.agenda.de.compromissos.Interfaces.Services;
using api.agenda.de.compromissos.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace api.agenda.de.compromissos.Services
{
    public class ConsultaService : IConsultaService
    {

        private readonly IConsultaRepository _consultaRepository;

        public ConsultaService(IConsultaRepository consultaRepository)
        {
            _consultaRepository = consultaRepository;
        }

        public void AgendarConsulta(ConsultaModel consulta)
        {
            if (this.ConsultaNoMesmoPeriodo(consulta))
                throw new ConsultasNoMesmoPeriodoException();

            if (this.ConsultaComDataFinalMenorQueDataInicial(consulta))
                throw new DataFinalMenorQueDataInicialException();

            _consultaRepository.AgendarConsulta(consulta);
        }

        public void FinalizarConsulta(int id)
        {
            _consultaRepository.FinalizarConsulta(id);
        }

        public void CancelarConsulta(int id)
        {
            _consultaRepository.CancelarConsulta(id);
        }

        public bool ConsultaComDataFinalMenorQueDataInicial(ConsultaModel consulta)
        {
            if (consulta.Fim < consulta.Inicio)
                return true;
            return false;
        }

        public bool ConsultaNoMesmoPeriodo(ConsultaModel consulta)
        {
            var consultas = _consultaRepository.Consultas();

            consultas = RemoverConsultasFinalizadasOuCanceladas(consultas);

            if (consultas.Count == 0)
                return false;


            if (consultas.Any(c => (c.Inicio <= consulta.Inicio && c.Fim >= consulta.Fim)
                || (c.Inicio >= consulta.Inicio && c.Fim <= consulta.Fim)
                || (c.Inicio >= consulta.Inicio && consulta.Fim >= c.Inicio && c.Fim >= consulta.Fim)
                || (c.Inicio <= consulta.Inicio && consulta.Inicio <= c.Fim && c.Fim <= consulta.Fim)))
                return true;
            return false;
        }

        public IList<ConsultaModel> Consultas()
        {
            return _consultaRepository.Consultas();
        }

        private IList<ConsultaModel> RemoverConsultasFinalizadasOuCanceladas(IList<ConsultaModel> consultas)
        {
            return consultas.Where(w => w.Finalizada == false && w.Cancelada == false).ToList();
        }
    }
}
