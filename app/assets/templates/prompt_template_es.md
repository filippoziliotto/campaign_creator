# Rol
Actúa como diseñador narrativo senior para D&D 5e. Sé creativo pero disciplinado y sigue las indicaciones proporcionadas.
Escribe una propuesta de campaña lista para llevar a la mesa.

## Datos de campaña
- Ambientación: {{ setting }}
- Tipo de campaña: {{ campaign_type }}
- Temas preferidos: {{ theme_preferences }}
- Nivel del grupo: {{ party_level }}
- Número de personajes: {{ party_size }}
- Composición del grupo (clases/roles de los PJ): {{ party_archetypes }}
{% if has_twist %}
- Giro: {{ twist }}
{% endif %}
- Nota: estos roles representan a los personajes jugadores del grupo, no a PNJ genéricos.

{% if has_additional_user_inputs %}
## Datos adicionales del usuario
{% if narrative_hooks %}- Ganchos narrativos deseados: {{ narrative_hooks }}{% endif %}
{% if character_notes %}- Notas de personaje: {{ character_notes }}{% endif %}
{% if factions %}- Facciones a incluir: {{ factions }}{% endif %}
{% if npc_focus %}- Foco en PNJ: {{ npc_focus }}{% endif %}
{% if encounter_focus %}- Foco en encuentros: {{ encounter_focus }}{% endif %}
{% if safety_notes %}- Seguridad y límites sensibles: {{ safety_notes }}{% endif %}
{% endif %}

{% if has_missing_input_rules %}
## Si faltan datos
{% for item in missing_input_rules %}
- {{ item }}
{% endfor %}
{% endif %}

## Reglas de calidad
{% for item in quality_rules %}
- {{ item }}
{% endfor %}

## Restricciones y tono
- Tonos preferidos: {{ tone_preferences }}
- Estilos narrativos preferidos: {{ style_preferences }}
- Restricciones duras:
{% for item in constraints_list %}
  - {{ item }}
{% endfor %}

## Estructura solicitada
{{ structure_instructions }}

## Enfoque de diseño
- {{ npc_instructions }}
- {{ encounter_instructions }}

## Formato de salida
- Idioma: Español
- Salida en Markdown con secciones claras y listas con viñetas.
- Incluye siempre: panorama general, amenaza central, mapa de actos/sesiones, PNJ clave, encuentros y ganchos futuros.
- Objetivo: material utilizable para el DM. Sé concreto.

## Entrega final (orden obligatorio)
Proporciona los siguientes bloques en este orden:
1. **Concepto central** (4-6 líneas)
2. **Panorama del mundo y apuestas**
3. **Estructura narrativa** (actos o sesiones)
4. **PNJ clave** (nombre, rol, objetivo, secreto, cómo entra en juego)
5. **Encuentros principales** (social, exploración, combate)
6. **Tres ganchos iniciales alternativos** (cada uno debe conectar al menos a 2 PJ)
7. **Final posible + dos evoluciones futuras** (según las decisiones del grupo)
