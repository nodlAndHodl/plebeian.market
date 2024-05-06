import NDK, { NDKEvent, NDKKind, NDKPrivateKeySigner } from '@nostr-dev-kit/ndk'
import { getAllStalls } from '$lib/server/stalls.service'
import { describe, expect, it } from 'vitest'

import { devUser1 } from '@plebeian/database'

describe('/products', () => {
	it('GET', async () => {
		const result = await fetch(`http://${process.env.APP_HOST}:${process.env.APP_PORT}/api/v1/products`).then((response) => response.json())

		expect(result).toHaveLength(10)
	})

	it('GET', async () => {
		const routeParams = {
			page: '1',
			pageSize: '15',
			order: 'desc',
			orderBy: 'price',
		}

		const result = await fetch(
			`http://${process.env.APP_HOST}:${process.env.APP_PORT}/api/v1/products?${new URLSearchParams(routeParams)}`,
		).then((response) => response.json())

		expect(result).toHaveLength(15)
	})

	it('POST', async () => {
		const stallId = await getAllStalls().then((stalls) => stalls[0].id)

		const skSigner = new NDKPrivateKeySigner(devUser1.sk)
		const ev = {
			id: Math.random().toString(36).substring(2, 15),
			stall_id: stallId,
			name: 'Hello Product',
			description: 'Hello Description',
			images: ['http://example.com/image1.jpg', 'http://example.com/image2.jpg'],
			currency: 'USD',
			price: 133,
			quantity: 6,
			specs: [
				['color', 'red'],
				['size', 'medium'],
			],
			shipping: [
				{
					id: Math.random().toString(36).substring(2, 15),
					cost: Math.random() * 10,
				},
			],
		}
		const newEvent = new NDKEvent(new NDK({ signer: skSigner }), {
			kind: 30018 as NDKKind,
			pubkey: devUser1.pk,
			content: JSON.stringify(ev),
			created_at: Math.floor(Date.now() / 1000),
			tags: [],
		})

		await newEvent.sign(skSigner)

		const result = await fetch(`http://${process.env.APP_HOST}:${process.env.APP_PORT}/api/v1/products`, {
			method: 'POST',
			body: JSON.stringify(newEvent),
			headers: {
				'Content-Type': 'application/json',
			},
		}).then((response) => response.json())

		expect(result).toStrictEqual({
			id: expect.any(String),
			createdAt: expect.any(String),
			currency: 'USD',
			description: 'Hello Description',
			galleryImages: [],
			mainImage: '',
			name: 'Hello Product',
			price: 133,
			stockQty: 6,
		})
	})

	it('GET products by user id', async () => {
		const result = await fetch(`http://${process.env.APP_HOST}:${process.env.APP_PORT}/api/v1/products?userId=testUserId`).then(
			(response) => response.json(),
		)

		expect(result).toHaveLength(10)
	})
})
