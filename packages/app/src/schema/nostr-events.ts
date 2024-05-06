import { z } from 'zod'

export const productEventSchema = z.object({
	id: z.string(),
	stall_id: z.string(),
	name: z.string(),
	description: z.string().optional(),
	images: z.array(z.string()).optional(),
	currency: z.string(),
	price: z.number(),
	quantity: z.number().int().nullable(),
	specs: z.array(z.tuple([z.string(), z.string()])),
	shipping: z.array(
		z.object({
			id: z.string(),
			cost: z.number(),
		}),
	),
})
