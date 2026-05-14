# === Основные цели для задания ===
.PHONY: setup test dev down build logs shell clear

prepare-env:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "DATABASE_HOST=db" >> .env; \
	fi

# Установка зависимостей и миграции (вызов make setup внутри контейнера)
setup: prepare-env
	docker-compose run --rm app make setup

# Запуск тестов в продакшен-режиме (без override, с возвратом кода выхода)
test: prepare-env
	docker-compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

# Запуск приложения в режиме разработки (с override, порт 8080)
dev: prepare-env
	docker-compose up

# Остановка и удаление контейнеров (без удаления томов)
down:
	docker-compose down

# Пересборка образов
build:
	docker-compose build

# Просмотр логов в реальном времени
logs:
	docker-compose logs -f

# Запуск bash внутри контейнера (для отладки)
shell:
	docker-compose run --rm app bash

# Полная очистка (остановка + удаление томов)
clear:
	docker-compose down -v

# === Дополнительные цели из твоего примера (адаптированы) ===
compose-up:
	docker-compose up -d

compose-production:
	docker-compose --file docker-compose.yml run production

compose-build: build

compose-logs: logs

compose-down: down

compose-clear: clear

compose-stop:
	docker-compose stop || true

compose-restart:
	docker-compose restart

# Составная цель: пересборка и установка (если нужно)
compose-setup: compose-down compose-build setup

ci: prepare-env
	docker compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app