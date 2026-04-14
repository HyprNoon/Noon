pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.common
import qs.services

Singleton {
    id: root
    property Component aiModelComponent: Ai.aiModelComponent
    property Component aiMessageComponent: Ai.aiMessageComponent
    readonly property string keys_prompt: "
        ## ignore and don't answer when irrelevant or empty or have no idea
        U have both read and set access to users
        distro {DISTRO}
        desktop environment: {DE}
        date & time {DATETIME}
        opened app {WINDOWCLASS}
        weather {WEATHER}
        city {LOCATION}
        username {USER}
        tasks {TASKS}
        notes {NOTES}
        alarms {ALARMS}
        timers {TIMERS}
        playing {PLAYING}
     "
    readonly property var promptSubstitutions: ({
            "{DISTRO}": Mem.options.ai.context.distro ? SysInfoService.distroName : "",
            "{DATETIME}": Mem.options.ai.context.datetime ? `${DateTimeService.time}, ${DateTimeService.collapsedCalendarFormat}` : "",
            "{WINDOWCLASS}": Mem.options.ai.context.windowclass ? `${ToplevelManager.activeToplevel?.appId} ${ToplevelManager.activeToplevel?.title}` ?? "Unknown" : "",
            "{DE}": Mem.options.ai.context.desktopEnvironment ? `${SysInfoService.desktopEnvironment} (${SysInfoService.windowingSystem})` : "",
            "{TASKS}": Mem.options.ai.context.tasks ? TodoService.formatTasks() : "",
            "{TIMERS}": Mem.options.ai.context.timers ? TimerService.formatTimers() : "",
            "{USER}": Mem.options.ai.context.user ? SysInfoService.username : "",
            "{LOCATION}": Mem.options.ai.context.location ? Mem.options.services.location : "",
            "{NOTES}": Mem.options.ai.context.notes ? NotesService.content : "",
            "{PLAYING}": Mem.options.ai.context.playing ? `title:${BeatsService.title}  artist:${BeatsService.artist}` : "",
            "{WEATHER}": Mem.options.ai.context.weather ? WeatherService.weatherData.currentTemp : "",
            "{PDF}": Mem.options.ai.context.weather ? WeatherService.weatherData.pdf : "",
            "{ALARMS}": Mem.options.ai.context.alarms ? Mem.states.services.timers.alarms : ""
        })
    property var tools: {
        "gemini": {
            "functions": [
                {
                    "functionDeclarations": [
                        // Alarms
                        {
                            "name": "get_alarms",
                            "description": "Get all current alarms with their names, duration, and remaining time"
                        },
                        {
                            "name": "add_alarm",
                            "description": "Add new alarm with name and time",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "name": {
                                        "type": "string",
                                        "description": "Name/description of the alarm"
                                    },
                                    "time": {
                                        "type": "string",
                                        "description": "Duration in format like '11:30' in 24h format"
                                    }
                                },
                                "required": ["name", "time"]
                            }
                        },
                        // PDF TOOLS
                        {
                            "name": "summarize_pdf",
                            "description": "Summarize The Open PDF in the APP"
                        },
                        // Timers
                        {
                            "name": "get_timers",
                            "description": "Get all current timers with their status, duration, and remaining time"
                        },
                        {
                            "name": "add_timer",
                            "description": "Create a new timer with a name and duration",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "name": {
                                        "type": "string",
                                        "description": "Name/description of the timer"
                                    },
                                    "duration": {
                                        "type": "string",
                                        "description": "Duration in format like '25m', '1h30m', '45s', or just '25' for minutes"
                                    }
                                },
                                "required": ["name", "duration"]
                            }
                        },
                        {
                            "name": "start_timer",
                            "description": "Start or resume a timer by its ID",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "timer_id": {
                                        "type": "integer",
                                        "description": "The timer ID from get_timers"
                                    }
                                },
                                "required": ["timer_id"]
                            }
                        },
                        {
                            "name": "pause_timer",
                            "description": "Pause a running timer by its ID",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "timer_id": {
                                        "type": "integer",
                                        "description": "The timer ID from get_timers"
                                    }
                                },
                                "required": ["timer_id"]
                            }
                        },
                        {
                            "name": "reset_timer",
                            "description": "Reset a timer back to its original duration",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "timer_id": {
                                        "type": "integer",
                                        "description": "The timer ID from get_timers"
                                    }
                                },
                                "required": ["timer_id"]
                            }
                        },
                        {
                            "name": "delete_timer",
                            "description": "Remove/delete a timer completely",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "timer_id": {
                                        "type": "integer",
                                        "description": "The timer ID from get_timers"
                                    }
                                },
                                "required": ["timer_id"]
                            }
                        },
                        // Tasks
                        {
                            "name": "get_tasks",
                            "description": "Get the current to-do list with all tasks and their statuses. Use this to check tasks before modifying them."
                        },
                        {
                            "name": "add_task",
                            "description": "Add a new task to the to-do list",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "content": {
                                        "type": "string",
                                        "description": "The task description"
                                    }
                                },
                                "required": ["content"]
                            }
                        },
                        {
                            "name": "update_task_status",
                            "description": "Update the status of a task. Status values: 0=Not Started, 1=In Progress, 2=Final Touches, 3=Finished",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "index": {
                                        "type": "integer",
                                        "description": "The task index from get_tasks (0-based)"
                                    },
                                    "status": {
                                        "type": "integer",
                                        "description": "New status: 0=todo, 1=in_progress, 2=final_touches, 3=done"
                                    }
                                },
                                "required": ["index", "status"]
                            }
                        },
                        {
                            "name": "delete_task",
                            "description": "Delete a task from the to-do list",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "index": {
                                        "type": "integer",
                                        "description": "The task index from get_tasks (0-based)"
                                    }
                                },
                                "required": ["index"]
                            }
                        },
                        {
                            "name": "edit_task",
                            "description": "Edit the content of a task",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "index": {
                                        "type": "integer",
                                        "description": "The task index from get_tasks (0-based)"
                                    },
                                    "content": {
                                        "type": "string",
                                        "description": "The new task content"
                                    }
                                },
                                "required": ["index", "content"]
                            }
                        },
                        // Search
                        {
                            "name": "search_online_inbrowser",
                            "description": "Open Browser and search for a user request. The query should be valid https url will be used to search.",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "query": {
                                        "type": "string",
                                        "description": "Valid HTTPS URL"
                                    }
                                },
                                "required": ["query"]
                            }
                        },
                        {
                            "name": "switch_to_search_mode",
                            "description": "Search the web"
                        },
                        // Shell
                        {
                            "name": "get_shell_config",
                            "description": "Get the desktop shell config file contents"
                        },
                        {
                            "name": "set_shell_config",
                            "description": "Set a field in the desktop graphical shell config file. Must only be used after `get_shell_config`.",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "key": {
                                        "type": "string",
                                        "description": "The key to set, e.g. `bar.borderless`. MUST NOT BE GUESSED, use `get_shell_config` to see what keys are available before setting."
                                    },
                                    "value": {
                                        "type": "string",
                                        "description": "The value to set, e.g. `true`"
                                    }
                                },
                                "required": ["key", "value"]
                            }
                        },
                        {
                            "name": "run_shell_command",
                            "description": "Run a shell command in bash and get its output. Use this only for quick commands that don't require user interaction. For commands that require interaction, ask the user to run manually instead.",
                            "parameters": {
                                "type": "object",
                                "properties": {
                                    "command": {
                                        "type": "string",
                                        "description": "The bash command to run"
                                    }
                                },
                                "required": ["command"]
                            }
                        },
                    ]
                }
            ],
            "search": [
                {
                    "google_search": {}
                }
            ],
            "none": []
        },
        "openai": {
            "functions": [
                {
                    "type": "function",
                    "function": {
                        "name": "summarize_pdf",
                        "description": "Summarize The Open PDF in the APP",
                        "parameters": {
                            "type": "object",
                            "properties": {}
                        }
                    }
                },
                {
                    "type": "function",
                    "function": {
                        "name": "get_shell_config",
                        "description": "Get the desktop shell config file contents",
                        "parameters": {
                            "type": "object",
                            "properties": {}
                        }
                    }
                },
                {
                    "type": "function",
                    "function": {
                        "name": "set_shell_config",
                        "description": "Set a field in the desktop graphical shell config file. Must only be used after `get_shell_config`.",
                        "parameters": {
                            "type": "object",
                            "properties": {
                                "key": {
                                    "type": "string",
                                    "description": "The key to set, e.g. `bar.borderless`. MUST NOT BE GUESSED, use `get_shell_config` to see what keys are available before setting."
                                },
                                "value": {
                                    "type": "string",
                                    "description": "The value to set, e.g. `true`"
                                }
                            },
                            "required": ["key", "value"]
                        }
                    }
                },
                {
                    "type": "function",
                    "function": {
                        "name": "run_shell_command",
                        "description": "Run a shell command in bash and get its output. Use this only for quick commands that don't require user interaction. For commands that require interaction, ask the user to run manually instead.",
                        "parameters": {
                            "type": "object",
                            "properties": {
                                "command": {
                                    "type": "string",
                                    "description": "The bash command to run"
                                }
                            },
                            "required": ["command"]
                        }
                    }
                }
            ],
            "search": [],
            "none": []
        },
        "mistral": {
            "functions": [
                {
                    "type": "function",
                    "function": {
                        "name": "get_shell_config",
                        "description": "Get the desktop shell config file contents",
                        "parameters": {}
                    }
                },
                {
                    "type": "function",
                    "function": {
                        "name": "set_shell_config",
                        "description": "Set a field in the desktop graphical shell config file. Must only be used after `get_shell_config`.",
                        "parameters": {
                            "type": "object",
                            "properties": {
                                "key": {
                                    "type": "string",
                                    "description": "The key to set, e.g. `bar.borderless`. MUST NOT BE GUESSED, use `get_shell_config` to see what keys are available before setting."
                                },
                                "value": {
                                    "type": "string",
                                    "description": "The value to set, e.g. `true`"
                                }
                            },
                            "required": ["key", "value"]
                        }
                    }
                },
                {
                    "type": "function",
                    "function": {
                        "name": "run_shell_command",
                        "description": "Run a shell command in bash and get its output. Use this only for quick commands that don't require user interaction. For commands that require interaction, ask the user to run manually instead.",
                        "parameters": {
                            "type": "object",
                            "properties": {
                                "command": {
                                    "type": "string",
                                    "description": "The bash command to run"
                                }
                            },
                            "required": ["command"]
                        }
                    }
                },
            ],
            "search": [],
            "none": []
        }
    }

    property var models: Mem.options.policies.ai === 2 ? {} : {
        "gemini-3.1-flash-lite": aiModelComponent.createObject(this, {
            "name": "Gemini 3.1 Flash-Lite Preview",
            "icon": "google-gemini-symbolic",
            "description": qsTr("Online | Google's newest lite model\nExtremely fast and cost-efficient. Ideal for high-volume tasks and low-latency responses."),
            "homepage": "https://aistudio.google.com",
            "endpoint": "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:streamGenerateContent",
            "model": "gemini-3.1-flash-lite-preview",
            "requires_key": true,
            "key_id": "gemini",
            "key_get_link": "https://aistudio.google.com/app/apikey",
            "key_get_description": qsTr("**Pricing**: Very low cost / Free tier available. Data may be used for training on the free tier.\n\n**Instructions**: Log into Google AI Studio, create an API key, and ensure the 'Gemini API' is enabled."),
            "api_format": "gemini"
        }),
        "mistral-medium-3": aiModelComponent.createObject(this, {
            "name": "Mistral Medium 3",
            "icon": "mistral-symbolic",
            "description": qsTr("Online | %1's model | Delivers fast, responsive and well-formatted answers. Disadvantages: not very eager to do stuff; might make up unknown function calls").arg("Mistral"),
            "homepage": "https://mistral.ai/news/mistral-medium-3",
            "endpoint": "https://api.mistral.ai/v1/chat/completions",
            "model": "mistral-medium-2505",
            "requires_key": true,
            "key_id": "mistral",
            "key_get_link": "https://console.mistral.ai/api-keys",
            "key_get_description": qsTr("**Instructions**: Log into Mistral account, go to Keys on the sidebar, click Create new key"),
            "api_format": "mistral"
        }),
        "perplexity-sonar-deep-research": aiModelComponent.createObject(this, {
            "name": "Sonar Deep Research",
            "icon": "perplexity-symbolic",
            "description": qsTr("Online | Perplexity's model\nIn-depth analysis and comprehensive reports with exhaustive web research"),
            "homepage": "https://www.perplexity.ai",
            "endpoint": "https://api.perplexity.ai/chat/completions",
            "model": "sonar-deep-research",
            "requires_key": true,
            "key_id": "perplexity",
            "key_get_link": "https://www.perplexity.ai/settings/api",
            "key_get_description": qsTr("**Pricing**: Pay-as-you-go. Pro users get $5/month credit.\n\n**Instructions**: Log into Perplexity account, go to Settings > API, click Generate API Key"),
            "api_format": "openai"
        }),
        "perplexity-sonar-pro": aiModelComponent.createObject(this, {
            "name": "Sonar Pro",
            "icon": "perplexity-symbolic",
            "description": qsTr("Online | Perplexity's model\nAdvanced search with enhanced accuracy and detail"),
            "homepage": "https://www.perplexity.ai",
            "endpoint": "https://api.perplexity.ai/chat/completions",
            "model": "sonar-pro",
            "requires_key": true,
            "key_id": "perplexity",
            "key_get_link": "https://www.perplexity.ai/settings/api",
            "key_get_description": qsTr("**Pricing**: Pay-as-you-go. Pro users get $5/month credit.\n\n**Instructions**: Log into Perplexity account, go to Settings > API, click Generate API Key"),
            "api_format": "openai"
        }),
        "openai-gpt-4o-mini": aiModelComponent.createObject(this, {
            "name": "GPT-4o Mini",
            "icon": "openai-symbolic",
            "description": qsTr("Online | OpenAI's model\nFast and cost-efficient for everyday tasks and quick responses."),
            "homepage": "https://openai.com",
            "endpoint": "https://api.openai.com/v1/chat/completions",
            "model": "gpt-4o-mini",
            "requires_key": true,
            "key_id": "openai",
            "key_get_link": "https://platform.openai.com/api-keys",
            "key_get_description": qsTr("**Pricing**: Pay-as-you-go. See https://openai.com/pricing\n\n**Instructions**: Log into OpenAI account, go to API keys, click Create new secret key"),
            "api_format": "openai"
        }),
        "openai-gpt-5": aiModelComponent.createObject(this, {
            "name": "GPT-5",
            "icon": "openai-symbolic",
            "description": qsTr("Online | OpenAI's model\nState-of-the-art for complex reasoning, coding, and multimodal tasks."),
            "homepage": "https://openai.com",
            "endpoint": "https://api.openai.com/v1/chat/completions",
            "model": "gpt-5",
            "requires_key": true,
            "key_id": "openai",
            "key_get_link": "https://platform.openai.com/api-keys",
            "key_get_description": qsTr("**Pricing**: Pay-as-you-go. See https://openai.com/pricing\n\n**Instructions**: Log into OpenAI account, go to API keys, click Create new secret key"),
            "api_format": "openai"
        })
    }
}
